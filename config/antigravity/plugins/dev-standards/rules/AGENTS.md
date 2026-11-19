# Core Software Engineering Guardrails (`dev-standards`)

1. **Strict Prohibition of Remote Push (`git push`):**
   - **NEVER** execute `git push`, `git push --force`, or any command that transmits commits to a remote repository.
   - Keep all commits strictly local and notify the user that changes are committed locally awaiting manual review.
2. **Mandatory Commit Specification (`git-commits`):**
   - Whenever preparing, structuring, or executing `git commit`, you **MUST** read and follow the `git-commits` skill.
3. **Mandatory Code Documentation Specification (`code-docs`):**
   - Whenever documenting code, writing docstrings, or adding technical comments, you **MUST** read and follow the `code-docs` skill and its corresponding language reference file.
