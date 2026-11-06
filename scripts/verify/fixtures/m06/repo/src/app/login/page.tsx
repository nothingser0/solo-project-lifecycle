import { useState } from "react";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [error, setError] = useState<string | null>(null);

  async function submit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    try {
      const response = await fetch("/api/session", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ email }),
      });
      if (!response.ok) {
        setError("Email atau kata sandi salah.");
      }
    } catch {
      setError("Tidak bisa menghubungi server. Coba lagi.");
    }
  }

  return (
    <main>
      <h1>Masuk</h1>
      <form onSubmit={submit}>
        <label htmlFor="email">Email</label>
        <input id="email" className="field-input" value={email} onChange={(e) => setEmail(e.target.value)} />
        <button type="submit">Masuk</button>
      </form>
      {error ? <p role="alert">{error}</p> : null}
    </main>
  );
}
