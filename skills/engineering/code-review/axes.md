# Five Axes of Code Review

Review every change across these five dimensions. See [SKILL.md](SKILL.md) for output format and severity levels.

## 1. Correctness

Does the code do what the spec says it should?

- Matches spec/task requirements?
- Edge cases handled (null, empty, boundary values)?
- Error paths handled (not just happy path)?
- Tests actually verify the behavior?
- Off-by-one errors, race conditions, state inconsistencies?

**Red flags:**
- Tests that only check if code exists, not if it works
- Happy-path-only testing
- Assertions that verify implementation details instead of behavior
- Ignored test files or skipped tests

## 2. Readability

Can another engineer understand this code without help?

- Names descriptive and consistent with project conventions?
- Control flow straightforward (avoid nested ternaries, deep callbacks)?
- Code organized logically (related code grouped, clear boundaries)?
- Any "clever" tricks that should be simplified?
- Could this be done in fewer lines?
- Are abstractions earning their complexity?

**Red flags:**
- `temp`, `data`, `result` as variable names without context
- Functions doing multiple unrelated things
- Deep nesting or callback chains
- Dead code: unused variables, backwards-compat shims, `// removed` comments
- Unexplained magic numbers or strings

## 3. Architecture

Does the change fit the system's design?

- Follows existing patterns or introduces a new one?
- Maintains clean module boundaries?
- Any code duplication that should be shared?
- Dependencies flowing in right direction (no circular deps)?
- Abstraction level appropriate (not over-engineered, not too coupled)?

**Red flags:**
- New pattern without justification or documentation
- Circular dependencies or tightly coupled modules
- Crossing layer boundaries (UI logic in backend, business logic in presentation)
- God objects or functions doing too much
- Violates SOLID principles in obvious ways

## 4. Security

For detailed security guidance, see `security-audit` skill. Does the change introduce vulnerabilities?

- User input validated and sanitized at boundaries?
- Secrets kept out of code, logs, version control?
- Authentication/authorization checked where needed?
- SQL queries parameterized (no string concatenation)?
- Outputs encoded to prevent XSS?
- Dependencies from trusted sources with no known CVEs?
- External data treated as untrusted?

**Red flags:**
- String concatenation in SQL queries
- Raw user input passed to system commands
- Secrets in code, env files checked in, hardcoded API keys
- Unvalidated redirect targets
- Missing auth checks on protected endpoints

## 5. Performance

For detailed profiling, see performance-optimization skill. Does the change introduce problems?

- N+1 query patterns?
- Unbounded loops or unconstrained data fetching?
- Synchronous operations that should be async?
- Unnecessary re-renders in UI?
- Missing pagination on list endpoints?
- Large objects created in hot paths?

**Red flags:**
- Loops with database queries (classic N+1)
- No pagination on list endpoints
- Blocking operations on main thread
- Exponential algorithms without constraint checks
- Repeatedly creating large data structures

## Summary Checklist

```
Correctness
  [ ] Code does what spec says
  [ ] Edge cases handled
  [ ] Error paths handled
  [ ] Tests verify behavior

Readability
  [ ] Names are clear
  [ ] Logic is straightforward
  [ ] No unnecessary complexity
  [ ] No dead code artifacts

Architecture
  [ ] Follows existing patterns
  [ ] Clean module boundaries
  [ ] No circular dependencies
  [ ] Right abstraction level

Security
  [ ] Input validated at boundaries
  [ ] Secrets out of code
  [ ] Auth checks in place
  [ ] External data treated as untrusted

Performance
  [ ] No N+1 queries
  [ ] No unbounded operations
  [ ] Pagination on lists
  [ ] Async where needed
```
