import { db } from "@/db";

export async function POST(request: Request) {
  const body = await request.json();
  if (!body || typeof body.productId !== "string") {
    return Response.json({ error: "productId required" }, { status: 400 });
  }
  const [row] = await db.query(
    "insert into orders (product_id) values ($1) returning id",
    [body.productId],
  );
  return Response.json(row, { status: 201 });
}
