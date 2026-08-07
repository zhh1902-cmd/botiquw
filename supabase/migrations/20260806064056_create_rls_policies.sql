/*
# RLS Policies for Content Tables

All content tables are publicly readable (no auth required) since this is a
public-facing boutique website. Write access is restricted to staff (admin/staff
role in raw_app_meta_data) via the is_staff() helper function.
*/

-- ─── Collections ───────────────────────────────────────────────
CREATE POLICY "read_collections" ON collections FOR SELECT
  TO anon, authenticated USING (deleted_at IS NULL);

CREATE POLICY "staff_insert_collections" ON collections FOR INSERT
  TO authenticated WITH CHECK (public.is_staff());

CREATE POLICY "staff_update_collections" ON collections FOR UPDATE
  TO authenticated USING (public.is_staff()) WITH CHECK (public.is_staff());

CREATE POLICY "staff_delete_collections" ON collections FOR DELETE
  TO authenticated USING (public.is_staff());

-- ─── Products ──────────────────────────────────────────────────
CREATE POLICY "read_products" ON products FOR SELECT
  TO anon, authenticated USING (deleted_at IS NULL);

CREATE POLICY "staff_insert_products" ON products FOR INSERT
  TO authenticated WITH CHECK (public.is_staff());

CREATE POLICY "staff_update_products" ON products FOR UPDATE
  TO authenticated USING (public.is_staff()) WITH CHECK (public.is_staff());

CREATE POLICY "staff_delete_products" ON products FOR DELETE
  TO authenticated USING (public.is_staff());

-- ─── Reviews ───────────────────────────────────────────────────
CREATE POLICY "read_reviews" ON reviews FOR SELECT
  TO anon, authenticated USING (deleted_at IS NULL);

CREATE POLICY "user_insert_reviews" ON reviews FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_update_reviews" ON reviews FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_delete_reviews" ON reviews FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- ─── Blog Posts ────────────────────────────────────────────────
CREATE POLICY "read_blog_posts" ON blog_posts FOR SELECT
  TO anon, authenticated USING (deleted_at IS NULL);

CREATE POLICY "staff_insert_blog_posts" ON blog_posts FOR INSERT
  TO authenticated WITH CHECK (public.is_staff());

CREATE POLICY "staff_update_blog_posts" ON blog_posts FOR UPDATE
  TO authenticated USING (public.is_staff()) WITH CHECK (public.is_staff());

CREATE POLICY "staff_delete_blog_posts" ON blog_posts FOR DELETE
  TO authenticated USING (public.is_staff());

-- ─── Hero Banners ──────────────────────────────────────────────
CREATE POLICY "read_hero_banners" ON hero_banners FOR SELECT
  TO anon, authenticated USING (deleted_at IS NULL);

CREATE POLICY "staff_insert_hero_banners" ON hero_banners FOR INSERT
  TO authenticated WITH CHECK (public.is_staff());

CREATE POLICY "staff_update_hero_banners" ON hero_banners FOR UPDATE
  TO authenticated USING (public.is_staff()) WITH CHECK (public.is_staff());

CREATE POLICY "staff_delete_hero_banners" ON hero_banners FOR DELETE
  TO authenticated USING (public.is_staff());

-- ─── Homepage Sections ────────────────────────────────────────
CREATE POLICY "read_homepage_sections" ON homepage_sections FOR SELECT
  TO anon, authenticated USING (deleted_at IS NULL);

CREATE POLICY "staff_insert_homepage_sections" ON homepage_sections FOR INSERT
  TO authenticated WITH CHECK (public.is_staff());

CREATE POLICY "staff_update_homepage_sections" ON homepage_sections FOR UPDATE
  TO authenticated USING (public.is_staff()) WITH CHECK (public.is_staff());

CREATE POLICY "staff_delete_homepage_sections" ON homepage_sections FOR DELETE
  TO authenticated USING (public.is_staff());

-- ─── Offers ───────────────────────────────────────────────────
CREATE POLICY "read_offers" ON offers FOR SELECT
  TO anon, authenticated USING (deleted_at IS NULL);

CREATE POLICY "staff_insert_offers" ON offers FOR INSERT
  TO authenticated WITH CHECK (public.is_staff());

CREATE POLICY "staff_update_offers" ON offers FOR UPDATE
  TO authenticated USING (public.is_staff()) WITH CHECK (public.is_staff());

CREATE POLICY "staff_delete_offers" ON offers FOR DELETE
  TO authenticated USING (public.is_staff());

-- ─── Gallery Images ───────────────────────────────────────────
CREATE POLICY "read_gallery_images" ON gallery_images FOR SELECT
  TO anon, authenticated USING (deleted_at IS NULL);

CREATE POLICY "staff_insert_gallery_images" ON gallery_images FOR INSERT
  TO authenticated WITH CHECK (public.is_staff());

CREATE POLICY "staff_update_gallery_images" ON gallery_images FOR UPDATE
  TO authenticated USING (public.is_staff()) WITH CHECK (public.is_staff());

CREATE POLICY "staff_delete_gallery_images" ON gallery_images FOR DELETE
  TO authenticated USING (public.is_staff());

-- ─── Videos ───────────────────────────────────────────────────
CREATE POLICY "read_videos" ON videos FOR SELECT
  TO anon, authenticated USING (deleted_at IS NULL);

CREATE POLICY "staff_insert_videos" ON videos FOR INSERT
  TO authenticated WITH CHECK (public.is_staff());

CREATE POLICY "staff_update_videos" ON videos FOR UPDATE
  TO authenticated USING (public.is_staff()) WITH CHECK (public.is_staff());

CREATE POLICY "staff_delete_videos" ON videos FOR DELETE
  TO authenticated USING (public.is_staff());

-- ─── FAQs ─────────────────────────────────────────────────────
CREATE POLICY "read_faqs" ON faqs FOR SELECT
  TO anon, authenticated USING (deleted_at IS NULL);

CREATE POLICY "staff_insert_faqs" ON faqs FOR INSERT
  TO authenticated WITH CHECK (public.is_staff());

CREATE POLICY "staff_update_faqs" ON faqs FOR UPDATE
  TO authenticated USING (public.is_staff()) WITH CHECK (public.is_staff());

CREATE POLICY "staff_delete_faqs" ON faqs FOR DELETE
  TO authenticated USING (public.is_staff());

-- ─── Site Settings ────────────────────────────────────────────
CREATE POLICY "read_site_settings" ON site_settings FOR SELECT
  TO anon, authenticated USING (deleted_at IS NULL);

CREATE POLICY "staff_insert_site_settings" ON site_settings FOR INSERT
  TO authenticated WITH CHECK (public.is_staff());

CREATE POLICY "staff_update_site_settings" ON site_settings FOR UPDATE
  TO authenticated USING (public.is_staff()) WITH CHECK (public.is_staff());

CREATE POLICY "staff_delete_site_settings" ON site_settings FOR DELETE
  TO authenticated USING (public.is_staff());