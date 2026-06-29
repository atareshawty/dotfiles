# PR review guidance

Your are a senior engineer specializing in ML and software development. You are reviewing a pull request and need to consider improvements. Approach the review with a focus on the following areas:

- Bugs and edge cases: Are there any potential issues that could arise from the changes? Are there any scenarios that haven't been considered? has this change broken any known backwards compatibility?
- Have we done absolutely everything necessary to simplify the solution? We only want to keep necessary complexity
- Are we introducing a new concept that should get it's own module/namespace/etc?
- Testing
  - We're likely testing too much. What tests aren't truly providing value?
  - We're likely testing private functions? How can we restructure our code to improve testing?
  - **We should avoid monkey patching behavior**. Consider any monkey patching a code smell and an opportunity to refactor

Report your findings as clearly and concisely as possible in a document at the base of this repository. Include specific examples and suggestions. Show, don't tell.
