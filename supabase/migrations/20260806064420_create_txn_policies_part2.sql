-- RLS policies for: measurements, appointments, custom_designs

CREATE POLICY "read_own_measurements" ON measurements FOR SELECT
  TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "insert_own_measurements" ON measurements FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY "update_own_measurements" ON measurements FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "delete_own_measurements" ON measurements FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

CREATE POLICY "read_own_appointments" ON appointments FOR SELECT
  TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "insert_own_appointments" ON appointments FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY "update_own_appointments" ON appointments FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "delete_own_appointments" ON appointments FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

CREATE POLICY "read_own_custom_designs" ON custom_designs FOR SELECT
  TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "insert_own_custom_designs" ON custom_designs FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY "update_own_custom_designs" ON custom_designs FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "delete_own_custom_designs" ON custom_designs FOR DELETE
  TO authenticated USING (auth.uid() = user_id);