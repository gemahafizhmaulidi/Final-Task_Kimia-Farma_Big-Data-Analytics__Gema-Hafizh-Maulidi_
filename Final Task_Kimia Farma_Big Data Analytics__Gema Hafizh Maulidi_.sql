INSERT INTO `dataset_kimia_farma.tabel_analisa` (
  transaction_id,
  date,
  branch_id,
  branch_name,
  kota,
  provinsi,
  rating_cabang,
  customer_name,
  product_id,
  product_name,
  actual_price,
  discount_percentage,
  gross_profit_percentage,
  nett_sales,
  nett_profit,
  rating_transaksi
)
SELECT
  ft.transaction_id,
  ft.date,
  b.branch_id,
  b.branch_name,
  b.kota,
  b.provinsi,
  b.rating AS rating_cabang,
  ft.customer_name,
  ft.product_id,
  p.product_name,
  ft.price AS actual_price,  -- Assuming 'price' column in 'kf_final_transaction'
  ft.discount_percentage,
  CASE
    WHEN ft.price <= 50000 THEN 0.1
    WHEN ft.price <= 100000 THEN 0.15
    WHEN ft.price <= 300000 THEN 0.2
    WHEN ft.price <= 500000 THEN 0.25
    ELSE 0.3
  END AS gross_profit_percentage,
  ft.price * (1 - ft.discount_percentage) AS nett_sales,
  ft.price * (CASE
    WHEN ft.price <= 50000 THEN 0.1
    WHEN ft.price <= 100000 THEN 0.15
    WHEN ft.price <= 300000 THEN 0.2
    WHEN ft.price <= 500000 THEN 0.25
    ELSE 0.3
  END) AS nett_profit,  -- Calculate nett_profit based on actual_price and gross_profit_percentage
  ft.rating AS rating_transaksi
FROM
  `dataset_kimia_farma.kf_final_transaction` AS ft
JOIN
  `dataset_kimia_farma.kf_product ` AS p
ON
  ft.product_id = p.product_id
JOIN
  `dataset_kimia_farma.kf_kantor_cabang` AS b
ON
  ft.branch_id = b.branch_id;
