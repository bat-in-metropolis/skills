---
name: "firebase-api-metrics-to-sheet"
description: "Fill a Google Sheet of API latency metrics (95th, 85th, median response time per API) using Firebase Performance network-request data for a start/end date the user gives. Starts with a preflight that checks sheet read/write access and Firebase access. Use when the user asks to update/fill the \"Test API Metrics\" style sheet, pull API response times from Firebase Performance, or refresh the weekly API metrics."
---

# Firebase API metrics -> Google Sheet

Fills the percentile columns (95th / 85th / Median response time) of a Google Sheet whose "API" column lists endpoints, using the Firebase Performance console. Built from a working run; follow the gotchas, they cost real time.

## Step 0: Get the sheet link, then run the preflight (fail fast)
Ask for the **Google Sheet link first**, before anything else. Then verify all four checks below BEFORE reading APIs or asking the remaining questions. Report a short pass/fail list to the user; if any check fails, stop and say exactly what the user must fix (don't continue half-way, and never enter passwords or work around a permission).

1. **Read access to the sheet.** Extract the file ID from the URL (`/d/<ID>/`) and call Drive `read_file_content`. Pass = content comes back. Fail = not found/denied -> user must share the sheet or connect Drive.
2. **Write (edit) access to the sheet.** Prefer a non-destructive check, never write test data:
   - Try Drive `get_file_permissions` / `get_file_metadata` for the user's role (editor/writer vs viewer/commenter).
   - Then confirm in the browser: open the sheet and look for the editing-mode indicator at the top right (pencil "Editing" = pass; "Viewing"/"View only"/"Request edit access" = fail). Note the Drive connector itself is read-only for cells; the browser is the write path.
   - Fail -> user needs Editor access (the sheet owner must grant it).
3. **Browser access + visibility.** Request access for `docs.google.com`, `console.firebase.google.com`, `accounts.google.com` (`request_access`). Call `tabs_context`; if the pane is hidden, ask the user to press Cmd+Shift+B (Sheets/screenshots don't render while hidden). If redirected to a Google sign-in page, the user must sign in themselves.
4. **Firebase read access.** Open one Firebase Performance detail page (URL pattern in Step 2) for any API from the sheet and confirm the "Distribution" panel renders with a value. Pass = number shown. Fail = sign-in page, "no access"/permission error, or project/app not found -> user needs access to the Firebase project or the right Google account.

Only after all four pass, continue.

## Inputs (ask in one AskUserQuestion round after the preflight, don't assume)
1. **Start date and end date** (e.g. start 3 Oct, end 9 Oct, include the year; default current year). Convert to Firebase's `time=START:END` param (epoch ms, IST = UTC+5:30 unless the user says otherwise):
   - START = midnight IST at the start of the start date = `Date.UTC(y,m-1,d,0,0,0) - 19800000`
   - END = 23:59:59 IST on the end date = `Date.UTC(y,m-1,d,23,59,59) - 19800000`
   - Example: 3 Oct 2026 to 9 Oct 2026 -> `time=1790965800000:1791570599000` (verified against Firebase's own custom-range URL). Compute with `javascript_tool` (`Date.UTC(...)`) if no shell is available. After opening the first detail page, confirm the header shows the expected range (e.g. "Oct 3 - Oct 9").
2. **Which columns to write**: the column for each of 95th, 85th and Median. Default: detect from the header row (e.g. "95th Percentile Response Time" -> D, "85th..." -> E, "Median..." -> F). Also confirm the **API column** (default: the column with the endpoint list, e.g. C) and the **first row to fill**; never overwrite cells the user already filled unless told to.
3. **Firebase project + app + host** (previous run: project `blackbuck-1085`, app `android:com.cpt_oe_react_app`, host `api-employee-bbpro.blackbuck.com`). The preflight's Firebase check should already use these.
4. Value convention: use the **Distribution value on each API's detail page** at 95% / 85% / 50%. NOT the summary table's "Response" column (latest-value figure; differs, e.g. 391 vs 405). If the user has a sample row filled, test the method against it first (expect a match within ~1 ms; data refreshes).

## Output format for values (applies to what is written to the sheet)
- Under 1000 ms: plain number, no unit (e.g. `405`).
- 1000 ms or more: seconds with an `s` suffix, e.g. 1234 ms -> `1.234s`.
- Firebase only displays 3 significant digits above 1s (e.g. `1.51s`, `2.52s`, `3.00s`), so write exactly what Firebase shows (`1.51s`), never invent extra digits. Tell the user this limit once if any value is >= 1s.
- Blank for APIs with no data.
- Cells that receive `1.51s` are text; that's expected.

## Tools
- Read sheet: Google Drive connector `read_file_content` (read-only; it cannot edit cells).
- Browser: built-in browser (`mcp__Claude_Browser__*`; load all with one ToolSearch `mcp__Claude_Browser__`).

## Step 1: Read the sheet
Read it via Drive. Note which row each API is on (row numbers matter for typing later), which rows are blank/separator, and the header cells that identify the percentile columns. Skip blank rows.

## Step 2: Find each API's full path in Firebase
Detail page URL pattern (replace every `/` with `~2F`, `*` stays literal):
```
https://console.firebase.google.com/u/0/project/<PROJECT>/performance/app/<APP>/troubleshooting/network/<HOST>~2F<path with ~2F>/response_time/response_time?time=<START>:<END>
```
Sheet paths are often wrong/short. Most were under `<HOST>/sales-service/...`; others under `/alchemist/...`, `/oms-wrapper/...`, `/rest/order/...`; some live elsewhere (e.g. attendance reports were `sales-service/attendance/report/demand/v1/aso`). Wildcard paths look like `los/*/stages-count`, `los/application/v4/*/summary`.
To discover a real path: open `.../performance/app/<APP>/trends?time=<START>:<END>` (wait ~10s; it auto-adds a harmless `version=` overlay, "All versions" is still primary), scroll to the "Network requests" table, click the search box (find "Search all domains and URLs"), TYPE with `computer type` + Enter (setting the input via JS does not filter), then read rows with `javascript_tool`: `document.body.innerText.split('\n').filter(s=>/\.(com|in|io)\//.test(s))`. Table page size maxes at 25 and JS pagination was unreliable; search per fragment instead.
A detail page for a non-existent/no-data path still loads with the right title but has NO "Distribution" panel (script returns "Trend over time | app_version"): treat as no data or wrong path; search the table before concluding. If the table has no row, leave the sheet cells blank and tell the user.

## Step 3: Read the three percentiles per API (automated)
The percentile picker is an Angular Material `mat-select`. Percentile is NOT in the URL, so switch it via JS on each page. Use `browser_batch` (max 25 actions per batch, and the batch times out at 180s, so <=4-5 APIs per batch): for each API `navigate` -> `computer wait 7` -> `javascript_tool`:
```js
const wait=ms=>new Promise(r=>setTimeout(r,ms)); const res={t:document.title.slice(15,100)};
for (const p of ['95%','85%','50%']) {
  const cb=document.querySelector('mat-select[aria-label^="Selected Percentile"]');
  if(!cb){res[p]='nocb';continue;}
  (cb.querySelector('.mat-mdc-select-trigger')||cb).click(); await wait(1200);
  const opt=[...document.querySelectorAll('mat-option')].find(o=>o.innerText.trim().startsWith(p));
  if(!opt){res[p]='noopt';continue;}
  opt.click(); await wait(3500);
  const t=document.body.innerText; const m=t.match(/Distribution[^\n]*\n([^\n]*)\n([^\n]*)/);
  res[p]=m? m[1]+' | '+m[2]:'NA';
}
JSON.stringify(res)
```
Coordinate clicks on the dropdown are unreliable; the JS above works. Always check the returned title matches the intended API and the label equals the requested percentile. Firebase returns values like `404 ms` or `1.51s`; convert to the output format above.

## Step 4: Review before writing
Make a table (API, p95, p85, p50, as they will be written) and note: APIs with no data, sheet labels that don't match their paths (e.g. two POD rows had labels/paths swapped; map by path), values shown rounded, and any difference from the user's sample. Also save a paste-ready TSV + labelled CSV in the outputs folder as a fallback. Get the user's OK if anything is surprising.

## Step 5: Write into the sheet (browser)
Needs the preflight to have passed (edit access, `docs.google.com` allowed, pane visible).
- Open the sheet; screenshot to confirm row numbers and column letters match the confirmed mapping.
- Jump via the Name box: click it (~(60,172) at full-frame), `computer type` the address (e.g. `D18`), `key Return`. (`computer type` does NOT enter text into grid cells; it only works for the Name box.)
- Enter data with `computer key` using space-separated real keys, max 100 tokens per call, e.g. `7 6 9 Tab 3 9 1 Tab 1 8 5 Return` (digits individually; Tab moves right; Return after Tabs goes back to the starting column of the next row). For `1.51s` press `1 period 5 1 s`; test one such cell first and confirm it shows `1.51s`. If the three percentile columns are not adjacent, write one column at a time instead (Name box to the first cell, then one value + `Return`/`Down` per row).
- **Blank rows: use `Down`, never `Return`** (Return on a selected blank cell enters edit mode and makes you drop a row). Even so, one Down was once dropped: screenshot every ~15 rows to verify alignment.
- If misaligned: Name box -> range (e.g. `D56:F68`) -> Return -> `Delete`, then re-enter from the correct row.
- Don't overwrite rows the user already filled; start below them.

## Step 6: Verify
Re-read the sheet with Drive `read_file_content` and compare every row against the expected values (the per-column "sample data" lists are easiest). Confirm blanks stayed blank, formats match the output rules (`405` vs `1.51s`), and the user's own sample row is unchanged.

## Report back
One short summary: preflight result, date range used, columns written, what was filled, which APIs have no data and why, label/path mismatches, the 3-significant-digit limit for values >= 1s, and any difference from the user's sample (e.g. 404 vs 405). Offer the non-API rows (crash-free users, cold start, etc. come from other Firebase screens) only if asked.

