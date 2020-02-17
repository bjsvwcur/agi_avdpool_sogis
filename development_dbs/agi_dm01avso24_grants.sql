-- Grant privileges on schemas
GRANT USAGE
ON SCHEMA agi_dm01avso24
TO public, gretl;

-- Grant read privileges
GRANT SELECT
ON ALL TABLES IN SCHEMA agi_dm01avso24
TO public;

-- Grant write privileges
GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA agi_dm01avso24
TO gretl;
GRANT USAGE
ON ALL SEQUENCES IN SCHEMA arp_npl
TO gretl;
