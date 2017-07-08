-- +micrate Up
CREATE TABLE entries(
  id bigint PRIMARY KEY NOT NULL,
  longitude float8,
  latitude float8,
  description text,
  image_url text,
  created_at timestamptz NOT NULL
);

-- +micrate Down
DROP TABLE entries;
