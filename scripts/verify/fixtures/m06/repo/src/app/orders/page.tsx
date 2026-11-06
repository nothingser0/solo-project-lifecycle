type Order = { id: string; total: number };

export default function OrdersPage({ orders }: { orders: Order[] }) {
  return (
    <main>
      <h1>Pesanan</h1>
      <table>
        <thead>
          <tr>
            <th>No</th>
            <th>Total</th>
          </tr>
        </thead>
        <tbody>
          {orders.map((order) => (
            <tr key={order.id}>
              <td>{order.id}</td>
              <td>{order.total}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </main>
  );
}
