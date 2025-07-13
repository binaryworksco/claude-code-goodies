# Working Notes

## Quick Notes
- Redis connection string from DevOps: `redis://cache-prod.internal:6379`
- JWT secret needs to be rotated quarterly - add to security calendar
- Consider adding Prometheus metrics for auth endpoints
- Frontend team prefers error codes over just messages

## Research Links
- [JWT Best Practices](https://tools.ietf.org/html/rfc8725) - RFC on JWT security
- [OWASP Authentication Cheatsheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
- [Refresh Token Rotation](https://auth0.com/docs/secure/tokens/refresh-tokens/refresh-token-rotation) - Auth0's approach
- [bcrypt vs Argon2](https://security.stackexchange.com/questions/193351) - Good comparison

## Code Snippets
```typescript
// Token rotation logic sketch
async function rotateRefreshToken(oldToken: string): Promise<TokenPair> {
  // 1. Validate old token
  // 2. Check if already used (replay attack)
  // 3. Generate new token pair
  // 4. Invalidate old refresh token family
  // 5. Return new tokens
}
```

```sql
-- Refresh tokens table design
CREATE TABLE refresh_tokens (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id),
  token_hash VARCHAR(255) NOT NULL UNIQUE,
  family_id UUID NOT NULL, -- for rotation tracking
  expires_at TIMESTAMP NOT NULL,
  used_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  device_info JSONB -- track device/browser
);
```

## TODO/Remember
- [ ] Ask frontend about preferred error format
- [ ] Check if we need CORS configuration for auth endpoints
- [ ] Verify email templates with marketing team
- [x] Add password strength meter endpoint
- [ ] Consider implementing account enumeration protection
- [ ] Add Sentry error tracking to auth module

## Questions for Team
- Do we want to log all authentication attempts for audit?
- Should we allow multiple sessions per user? How many?
- What's the policy on password reuse? Last 3? 5?
- Do we need to support API key authentication for services?

## Debugging Notes
- JWT validation failing: Check clock skew between servers
- bcrypt taking too long: Consider reducing cost factor for tests
- Email not sending: Sandbox mode might be enabled
- Token refresh failing: Check if old token already used

## Performance Observations
- Login endpoint: ~250ms (mostly bcrypt)
- Registration: ~300ms (bcrypt + db write)
- Token refresh: ~50ms
- Need to add caching for user permissions

## Security Considerations
- Rate limit: 5 attempts per 15 min per IP
- Add CAPTCHA after 3 failed attempts?
- Log all password reset attempts
- Consider adding honey pot fields to registration

## Migration Notes
```bash
# Commands for database setup
npm run db:migrate
npm run db:seed:auth # adds test users

# Test users created:
# test@example.com / Password123!
# admin@example.com / AdminPass456!
```

---

**Last cleaned**: Never (still actively working)