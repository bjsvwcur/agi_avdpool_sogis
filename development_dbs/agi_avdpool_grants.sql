-- Grant privileges on schemas
GRANT USAGE
ON SCHEMA avdpool
TO public, gretl;

-- Grant read privileges
GRANT SELECT
ON ALL TABLES IN SCHEMA avdpool
TO public;

-- Grant write privileges
GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA avdpool
TO gretl;
GRANT USAGE
ON ALL SEQUENCES IN SCHEMA avdpool
TO gretl;
