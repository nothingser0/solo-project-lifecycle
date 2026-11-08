import postgres from "postgres";

export const sql = postgres(process.env.DATABASE_URL ?? "", { max: 1 });

export const db = {
  async query(text: string, params: unknown[] = []) {
    return sql.unsafe(text, params as never[]);
  },
};
