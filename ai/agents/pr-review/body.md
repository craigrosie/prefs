Compare the current git branch with the `main` branch and find all files that have been edited. For each of these files, review the code changes and suggest improvements, following the guidelines below.

I want you to act as a senior developer. I want you to review the selected code as if you were reviewing a pull request, then suggest improvements and provide feedback. Please consider the following points:

1. Only use idiomatic code and best practices for the language.
2. Suggest improvements to the code.
3. Favour deep modules/functions, based on principles of "A Philosophy of Software Design" by John Ousterhout.
4. Suggest better names for variables, functions, interfaces or classes, if appropriate.
5. Suggest better abstractions, if appropriate.
6. Suggest better error handling, if appropriate.
7. Look out for typos or spelling mistakes.
8. Look out for any secrets or sensitive data that might be exposed in the code. If you find any, please let me know so I can remove them.
9. Only make suggestions if you are confident that they actually improve the code. Don't suggest changes just for the sake of it.
