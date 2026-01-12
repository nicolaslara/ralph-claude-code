# Testing Knowledge Base

Testing strategies, patterns, and lessons learned.

## Table of Contents
- [Testing Pyramid](#testing-pyramid)
- [Test Commands](#test-commands)
- [Patterns](#patterns)
- [Lessons Learned](#lessons-learned)

---

## Testing Pyramid

```
        /\
       /E2E\        <- Few, slow, high confidence
      /------\
     /Integration\  <- Some, medium speed
    /------------\
   /    Unit      \ <- Many, fast, focused
  /________________\
```

---

## Test Commands

```bash
# Unit tests
npm run test

# Type checking
npm run typecheck

# E2E tests (if applicable)
npm run test:e2e
```

---

## Patterns

### Unit Test Template
```typescript
describe('ComponentName', () => {
  it('should [expected behavior]', () => {
    // Arrange
    // Act
    // Assert
  });
});
```

---

## Lessons Learned

- [Testing lesson]
