/* 004 — Campos que o código de 2022 usa e o banco do repositório não tem.
   Achados ao abrir as consultas no Lazarus (testes/TesteNucleo) e conferidos em todas as telas com
   ferramentas/campos_x_banco.py. Sem eles a consulta nem abre ("Field not found"), no Lazarus e no Delphi. */

/* dmPDV.qryVenda e FrmPDV.qryVenda: KM e PLACA (TStringField, Size 7) */
ALTER TABLE VENDAS_MASTER ADD KM VARCHAR(7);
ALTER TABLE VENDAS_MASTER ADD PLACA VARCHAR(7);

COMMIT;
