// Universal k6 Load Test Script
// Usage: k6 run scripts/load-test.js
// Environment variables:
//   BASE_URL - Target host (default: http://localhost:3000)
//   VUS      - Max concurrent virtual users (default: 50)
//   DURATION - Sustained load duration (default: 30s)

import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE_URL = __ENV.BASE_URL || 'http://localhost:3000';
const TARGET_VUS = parseInt(__ENV.VUS || '50', 10);
const DURATION = __ENV.DURATION || '30s';

export const options = {
  stages: [
    { duration: '10s', target: Math.floor(TARGET_VUS / 2) }, // Ramp-up
    { duration: DURATION, target: TARGET_VUS },             // Steady sustained load
    { duration: '10s', target: 0 },                         // Ramp-down
  ],
  thresholds: {
    http_req_duration: ['p(95)<200', 'p(99)<500'],         // 95% requests < 200ms, 99% < 500ms
    http_req_failed: ['rate<0.01'],                         // Error rate < 1%
  },
};

export default function () {
  // 1. Healthcheck / Public Landing Page
  const resHome = http.get(`${BASE_URL}/`);
  check(resHome, {
    'landing page status 200': (r) => r.status === 200,
    'landing page latency < 200ms': (r) => r.timings.duration < 200,
  });

  sleep(0.5);

  // 2. Healthcheck / Ping endpoint
  const resHealth = http.get(`${BASE_URL}/api/health`, {
    headers: { 'Accept': 'application/json' },
  });
  check(resHealth, {
    'health endpoint status is 200 or 404': (r) => r.status === 200 || r.status === 404,
  });

  sleep(0.5);

  // 3. Simulated Resource Query
  const resApi = http.get(`${BASE_URL}/api/v1/ping`, {
    headers: { 'User-Agent': 'k6-load-tester/1.0' },
  });
  check(resApi, {
    'api ping responded': (r) => r.status !== 500,
  });

  sleep(1);
}
