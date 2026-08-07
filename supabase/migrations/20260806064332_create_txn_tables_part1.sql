-- Transactional tables: orders, order_items, wishlist, cart, addresses

CREATE TABLE IF NOT EXISTS orders (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  order_number    text NOT NULL UNIQUE,
  status          text NOT NULL DEFAULT 'pending',
  total           numeric(10,2) NOT NULL CHECK (total >= 0),
  subtotal        numeric(10,2) NOT NULL CHECK (subtotal >= 0),
  shipping        numeric(10,2) NOT NULL DEFAULT 0,
  gst             numeric(10,2) NOT NULL DEFAULT 0,
  payment_method  text NOT NULL DEFAULT 'cod',
  full_name       text NOT NULL,
  phone           text NOT NULL,
  email           text,
  address_line1   text NOT NULL,
  address_line2   text,
  city            text NOT NULL,
  state           text NOT NULL,
  pincode         text NOT NULL,
  delivery_notes  text,
  gift_message    text,
  tracking_steps  jsonb NOT NULL DEFAULT '[]'::jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS order_items (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id      uuid NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id    uuid REFERENCES products(id) ON DELETE SET NULL,
  product_name  text NOT NULL,
  product_image text,
  size          text,
  color         text,
  quantity      int NOT NULL CHECK (quantity > 0),
  price         numeric(10,2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE IF NOT EXISTS wishlist_items (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  product_id uuid NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(user_id, product_id)
);

CREATE TABLE IF NOT EXISTS cart_items (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  product_id uuid NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  quantity   int NOT NULL DEFAULT 1 CHECK (quantity > 0),
  size       text,
  color      text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS addresses (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  label      text NOT NULL,
  full_name  text NOT NULL,
  phone      text NOT NULL,
  line1      text NOT NULL,
  line2      text,
  city       text NOT NULL,
  state      text NOT NULL,
  pincode    text NOT NULL,
  is_default boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);