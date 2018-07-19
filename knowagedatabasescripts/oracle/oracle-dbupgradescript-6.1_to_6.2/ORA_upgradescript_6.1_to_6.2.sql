INSERT into SBI_DOMAINS (VALUE_ID, VALUE_CD, VALUE_NM, DOMAIN_CD, DOMAIN_NM,VALUE_DS, USER_IN,TIME_IN) values ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_DOMAINS'), 'Date', 'Date', 'DS_META_VALUE', 'Dataset Metadata Value', 'Dataset Metadata Value', ' ',SYSTIMESTAMP);
UPDATE hibernate_sequences SET next_val = (SELECT MAX(VALUE_ID) + 1 FROM SBI_DOMAINS) WHERE sequence_name = 'SBI_DOMAINS';

UPDATE SBI_FEDERATION_DEFINITION SET NAME = LABEL WHERE NAME IS NULL;
ALTER TABLE SBI_FEDERATION_DEFINITION MODIFY NAME NOT NULL;

ALTER TABLE SBI_EXT_ROLES ADD IS_PUBLIC SMALLINT NULL;

ALTER TABLE SBI_DATA_SOURCE ADD JDBC_ADVANCED_CONFIGURATION	VARCHAR2(4000);

INSERT into SBI_DOMAINS (VALUE_ID, VALUE_CD, VALUE_NM, DOMAIN_CD, DOMAIN_NM,VALUE_DS, USER_IN,TIME_IN) values ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_DOMAINS'), 'Solr', 'SbiSolrDataSet', 'DATA_SET_TYPE', 'Data Set Type', 'SbiSolrDataSet', ' ',SYSTIMESTAMP);
UPDATE hibernate_sequences SET next_val = (SELECT MAX(VALUE_ID) + 1 FROM SBI_DOMAINS) WHERE sequence_name = 'SBI_DOMAINS';

DELETE FROM SBI_PRODUCT_TYPE_ENGINE WHERE ENGINE_ID = (
    SELECT ENGINE_ID FROM SBI_ENGINES WHERE BIOBJ_TYPE = (
        SELECT VALUE_ID FROM SBI_DOMAINS WHERE DOMAIN_CD = 'BIOBJ_TYPE' AND VALUE_CD = 'ACCESSIBLE_HTML'
    )
);
 
DELETE FROM SBI_ENGINES WHERE BIOBJ_TYPE = (
    SELECT VALUE_ID FROM SBI_DOMAINS WHERE DOMAIN_CD = 'BIOBJ_TYPE' AND VALUE_CD = 'ACCESSIBLE_HTML'
);
 
DELETE FROM SBI_DOMAINS WHERE DOMAIN_CD = 'BIOBJ_TYPE' AND VALUE_CD = 'ACCESSIBLE_HTML';

ALTER TABLE SBI_ATTRIBUTE MODIFY (DESCRIPTION VARCHAR2(500) NULL);

ALTER TABLE SBI_OUTPUT_PARAMETER MODIFY FORMAT_VALUE VARCHAR2(30);

ALTER TABLE SBI_FEDERATION_DEFINITION ADD OWNER VARCHAR2(100) NULL;

-- STATEMENT START
DELETE FROM SBI_EXPORTERS WHERE ENGINE_ID IN (SELECT ENGINE_ID FROM SBI_ENGINES WHERE DRIVER_NM = 'it.eng.spagobi.engines.drivers.qbe.QbeDriver') 
AND 
DOMAIN_ID IN (SELECT VALUE_ID FROM SBI_DOMAINS WHERE DOMAIN_CD = 'EXPORT_TYPE' AND VALUE_CD IN ('PDF', 'RTF', 'JRXML'));

UPDATE SBI_EXPORTERS SET DEFAULT_VALUE = 1 WHERE ENGINE_ID IN (SELECT ENGINE_ID FROM SBI_ENGINES WHERE DRIVER_NM = 'it.eng.spagobi.engines.drivers.qbe.QbeDriver')
AND
DOMAIN_ID IN (SELECT VALUE_ID FROM SBI_DOMAINS WHERE DOMAIN_CD = 'EXPORT_TYPE' AND VALUE_CD = 'XLS');

commit;
-- STATEMENT END

-- STATEMENT START
ALTER TABLE SBI_DATA_SOURCE DROP CONSTRAINT XAK1SBI_DATA_SOURCE DROP INDEX;

ALTER TABLE SBI_DATA_SOURCE ADD CONSTRAINT XAK1SBI_DATA_SOURCE UNIQUE (LABEL);
-- STATEMENT END
