# Final Evidence

- Setup: artifacts/setup.png
- Database: artifacts/db.png
- API: artifacts/api.png
- Screen SCR-001: artifacts/fe-1.png
- Screen SCR-002: artifacts/fe-2.png
- QA: artifacts/qa.png

Every artifact above exists in this repository.

## Database proof

Against localhost (postgres://localhost:5432/kasir):

```
localhost$ npm run migrate:down   # rollback succeeds
localhost$ SELECT COUNT(*) FROM products;   # seeder count = 12
localhost$ EXPLAIN SELECT id FROM products ORDER BY name;   # index scan
```
