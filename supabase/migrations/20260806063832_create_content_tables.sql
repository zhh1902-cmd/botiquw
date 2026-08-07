/*
# Create content tables for Sri Harshini Boutique

## Overview
This migration creates 11 content tables that store publicly-readable boutique
content: collections, products, reviews, blog posts, hero banners, homepage
sections, offers, gallery images, videos, FAQs, and site settings.

## New Tables
1. collections — product collections (bridal, wedding, festival, etc.)
2. products — product catalog with images, pricing, fabric, colors, sizes
3. reviews — customer reviews linked to products and users
4. blog_posts — journal articles with cover image, category, author
5. hero_banners — home page hero slider content with CTAs
6. homepage_sections — flexible JSON-based homepage section config
7. offers — promotional offers with coupon codes and discount rules
8. gallery_images — photo gallery with categories and dimensions
9. videos — video gallery with thumbnails and duration
10. faqs — frequently asked questions grouped by category
11. site_settings — key-value store for site-wide configuration

## Constraints & Indexes
- Unique slugs on collections, products, blog_posts
- Unique keys on site_settings, homepage_sections
- Foreign keys: products→collections, reviews→products, reviews→auth.users
- Check constraints: product price > 0, review rating 1–5
- Indexes on all frequently-filtered columns (slug, category, featured, active, sort_order)

## Timestamps & Soft Deletes
- created_at timestamptz DEFAULT now()
- updated_at timestamptz DEFAULT now() (auto-updated via trigger)
- deleted_at timestamptz NULL (soft delete column)

## Security
- RLS enabled on every table (policies added in a separate migration)
- is_staff() helper function checks raw_app_meta_data role for admin/staff
*/

-- ─── Helper Functions ──────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.is_staff()
RETURNS boolean
LANGUAGE sql
STABLE
AS $$
  SELECT COALESCE(
    (auth.jwt() -> 'raw_app_meta_data' ->> 'role') IN ('admin', 'staff'),
    false
  );
$$;

-- ─── Collections ────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS collections (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug        text NOT NULL UNIQUE,
  name        text NOT NULL,
  tagline     text,
  description text,
  image_url   text NOT NULL,
  cover_url   text,
  sort_order  int  NOT NULL DEFAULT 0,
  featured    boolean NOT NULL DEFAULT false,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),
  deleted_at  timestamptz
);

CREATE INDEX IF NOT EXISTS idx_collections_featured ON collections(featured) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_collections_sort_order ON collections(sort_order) WHERE deleted_at IS NULL;

-- ─── Products ──────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS products (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug              text NOT NULL UNIQUE,
  name              text NOT NULL,
  collection_id     uuid REFERENCES collections(id) ON DELETE SET NULL,
  short_description text NOT NULL,
  description       text NOT NULL,
  price             numeric(10,2) NOT NULL CHECK (price > 0),
  compare_at_price numeric(10,2),
  images            text[] NOT NULL DEFAULT '{}',
  video_url         text,
  fabric            text,
  thread            text,
  stone_work        text,
  occasion          text,
  colors            text[] NOT NULL DEFAULT '{}',
  sizes             text[] NOT NULL DEFAULT '{}',
  availability      text NOT NULL DEFAULT 'In Stock',
  stock_status      text NOT NULL DEFAULT 'available',
  rating            numeric(2,1) NOT NULL DEFAULT 0,
  review_count      int NOT NULL DEFAULT 0,
  tags              text[] NOT NULL DEFAULT '{}',
  best_seller       boolean NOT NULL DEFAULT false,
  trending          boolean NOT NULL DEFAULT false,
  limited_edition   boolean NOT NULL DEFAULT false,
  latest            boolean NOT NULL DEFAULT false,
  sort_order        int NOT NULL DEFAULT 0,
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now(),
  deleted_at        timestamptz
);

CREATE INDEX IF NOT EXISTS idx_products_collection_id ON products(collection_id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_products_sort_order ON products(sort_order) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_products_best_seller ON products(best_seller) WHERE deleted_at IS NULL AND best_seller = true;
CREATE INDEX IF NOT EXISTS idx_products_trending ON products(trending) WHERE deleted_at IS NULL AND trending = true;
CREATE INDEX IF NOT EXISTS idx_products_latest ON products(latest) WHERE deleted_at IS NULL AND latest = true;
CREATE INDEX IF NOT EXISTS idx_products_limited ON products(limited_edition) WHERE deleted_at IS NULL AND limited_edition = true;
CREATE INDEX IF NOT EXISTS idx_products_created_at ON products(created_at DESC) WHERE deleted_at IS NULL;

-- ─── Reviews ───────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS reviews (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id    uuid NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  user_id       uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  author_name   text NOT NULL,
  rating        int NOT NULL CHECK (rating >= 1 AND rating <= 5),
  title         text NOT NULL,
  body          text NOT NULL,
  photo_url     text,
  video_url     text,
  verified      boolean NOT NULL DEFAULT false,
  helpful_votes int NOT NULL DEFAULT 0,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  deleted_at    timestamptz
);

CREATE INDEX IF NOT EXISTS idx_reviews_product_id ON reviews(product_id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_reviews_user_id ON reviews(user_id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_reviews_created_at ON reviews(created_at DESC) WHERE deleted_at IS NULL;

-- ─── Blog Posts ────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS blog_posts (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug         text NOT NULL UNIQUE,
  title        text NOT NULL,
  excerpt      text NOT NULL,
  body         text NOT NULL,
  cover_url    text NOT NULL,
  category     text NOT NULL DEFAULT 'General',
  author       text NOT NULL DEFAULT 'Sri Harshini Boutique',
  read_time    int NOT NULL DEFAULT 5,
  published_at timestamptz NOT NULL DEFAULT now(),
  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now(),
  deleted_at   timestamptz
);

CREATE INDEX IF NOT EXISTS idx_blog_posts_published_at ON blog_posts(published_at DESC) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_blog_posts_category ON blog_posts(category) WHERE deleted_at IS NULL;

-- ─── Hero Banners ──────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS hero_banners (
  id                   uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title                text NOT NULL,
  subtitle             text,
  image_url            text NOT NULL,
  video_url            text,
  primary_cta_label    text,
  primary_cta_link     text,
  secondary_cta_label  text,
  secondary_cta_link  text,
  sort_order           int NOT NULL DEFAULT 0,
  active               boolean NOT NULL DEFAULT true,
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now(),
  deleted_at           timestamptz
);

CREATE INDEX IF NOT EXISTS idx_hero_banners_active ON hero_banners(active) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_hero_banners_sort_order ON hero_banners(sort_order) WHERE deleted_at IS NULL;

-- ─── Homepage Sections ────────────────────────────────────────

CREATE TABLE IF NOT EXISTS homepage_sections (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  section_key text NOT NULL UNIQUE,
  title       text,
  subtitle    text,
  content     jsonb NOT NULL DEFAULT '{}'::jsonb,
  sort_order  int NOT NULL DEFAULT 0,
  active      boolean NOT NULL DEFAULT true,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),
  deleted_at  timestamptz
);

CREATE INDEX IF NOT EXISTS idx_homepage_sections_active ON homepage_sections(active) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_homepage_sections_sort_order ON homepage_sections(sort_order) WHERE deleted_at IS NULL;

-- ─── Offers ───────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS offers (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title         text NOT NULL,
  description   text,
  coupon_code   text,
  discount_type text NOT NULL DEFAULT 'percentage',
  discount_value numeric(10,2) NOT NULL DEFAULT 0,
  min_order     numeric(10,2),
  ends_at       timestamptz,
  active        boolean NOT NULL DEFAULT true,
  sort_order    int NOT NULL DEFAULT 0,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  deleted_at    timestamptz
);

CREATE INDEX IF NOT EXISTS idx_offers_active ON offers(active) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_offers_sort_order ON offers(sort_order) WHERE deleted_at IS NULL;

-- ─── Gallery Images ───────────────────────────────────────────

CREATE TABLE IF NOT EXISTS gallery_images (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title      text,
  image_url  text NOT NULL,
  category   text NOT NULL DEFAULT 'General',
  width      int,
  height     int,
  sort_order int NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);

CREATE INDEX IF NOT EXISTS idx_gallery_images_category ON gallery_images(category) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_gallery_images_sort_order ON gallery_images(sort_order) WHERE deleted_at IS NULL;

-- ─── Videos ───────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS videos (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title         text NOT NULL,
  category      text NOT NULL DEFAULT 'General',
  video_url     text NOT NULL,
  thumbnail_url text,
  duration      text,
  sort_order    int NOT NULL DEFAULT 0,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  deleted_at    timestamptz
);

CREATE INDEX IF NOT EXISTS idx_videos_category ON videos(category) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_videos_sort_order ON videos(sort_order) WHERE deleted_at IS NULL;

-- ─── FAQs ─────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS faqs (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category   text NOT NULL DEFAULT 'General',
  question   text NOT NULL,
  answer     text NOT NULL,
  sort_order int NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);

CREATE INDEX IF NOT EXISTS idx_faqs_category ON faqs(category) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_faqs_sort_order ON faqs(sort_order) WHERE deleted_at IS NULL;

-- ─── Site Settings ────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS site_settings (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  key        text NOT NULL UNIQUE,
  value      text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);

-- ─── Triggers for updated_at ───────────────────────────────────

DO $$
DECLARE
  tbl text;
BEGIN
  FOR tbl IN
    SELECT unnest(ARRAY[
      'collections','products','reviews','blog_posts','hero_banners',
      'homepage_sections','offers','gallery_images','videos','faqs','site_settings'
    ])
  LOOP
    EXECUTE format(
      'DROP TRIGGER IF EXISTS trg_set_updated_at ON %I; CREATE TRIGGER trg_set_updated_at BEFORE UPDATE ON %I FOR EACH ROW EXECUTE FUNCTION set_updated_at();',
      tbl, tbl
    );
  END LOOP;
END;
$$;

-- ─── Enable RLS on all tables ──────────────────────────────────

ALTER TABLE collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE blog_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE hero_banners ENABLE ROW LEVEL SECURITY;
ALTER TABLE homepage_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE offers ENABLE ROW LEVEL SECURITY;
ALTER TABLE gallery_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE videos ENABLE ROW LEVEL SECURITY;
ALTER TABLE faqs ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;