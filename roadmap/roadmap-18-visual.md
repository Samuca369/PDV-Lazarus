# Roadmap 18 — Visual

**Objetivo:** Recuperar o acabamento sem os estilos do Delphi.

**Depende de:** roadmap 8

## Passos

- [ ] Definir cores, fontes e ícones (o Lazarus não tem VCL Styles).
- [ ] Aplicar na tela de venda, no pagamento e no menu do ERP; depois no resto.
- [ ] Atalhos do rodapé da venda sobrepostos com a escala do Windows acima de 100%. O `uPDV` posiciona esses textos
      em pixels fixos (`aBotoesLeft`/`aBotoesTop`); usar `Scale96ToForm` (achado no roadmap 4).
- [ ] Logotipo: a tela de venda e a de pagamento mostram o texto "CLIQUE E COLOQUE SUA LOGO AQUI" quando não há
      imagem.
- [ ] Pagamento, tela "Tipo de Impressão": os botões F3 a F6 ficam cortados embaixo (achado no roadmap 5).

## Pronto quando

As telas principais ficam com o acabamento aprovado por você.
