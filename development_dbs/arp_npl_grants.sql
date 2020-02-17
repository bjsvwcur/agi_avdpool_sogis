-- Grant privileges on schemas
GRANT USAGE
ON SCHEMA arp_npl
TO public, gretl;

-- Grant read privileges
GRANT SELECT
ON ALL TABLES IN SCHEMA arp_npl
TO public;

-- Grant write privileges
GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA arp_npl
TO gretl;
GRANT USAGE
ON ALL SEQUENCES IN SCHEMA arp_npl
TO gretl;
