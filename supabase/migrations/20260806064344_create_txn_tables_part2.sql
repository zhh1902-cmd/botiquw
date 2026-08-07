-- Transactional tables: measurements, appointments, custom_designs

CREATE TABLE IF NOT EXISTS measurements (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  label          text NOT NULL,
  dress_type     text NOT NULL,
  shoulder       numeric(5,1),
  chest          numeric(5,1),
  waist          numeric(5,1),
  hip            numeric(5,1),
  length         numeric(5,1),
  sleeve_length  numeric(5,1),
  neck_depth     numeric(5,1),
  notes          text,
  created_at     timestamptz NOT NULL DEFAULT now(),
  updated_at     timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS appointments (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  type            text NOT NULL,
  preferred_date  date NOT NULL,
  preferred_time  text NOT NULL,
  dress_type      text,
  notes           text,
  status          text NOT NULL DEFAULT 'pending',
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS custom_designs (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  occasion         text,
  fabric           text,
  thread           text,
  embroidery_type  text,
  stone_type       text,
  mirror_work      boolean NOT NULL DEFAULT false,
  neck_style       text,
  sleeve_style     text,
  back_neck        text,
  border_style     text,
  budget           numeric(10,2),
  deadline         date,
  inspiration_urls text[] NOT NULL DEFAULT '{}',
  notes            text,
  status           text NOT NULL DEFAULT 'pending',
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now()
);