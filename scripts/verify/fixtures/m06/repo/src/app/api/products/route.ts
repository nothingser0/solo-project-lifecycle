import { db } from "@/db";

export async function GET() {
  const rows = await db.query("select id, name from products order by name");
  return Response.json(rows);
}
