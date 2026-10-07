MAIN := presentation-2026-ai-chatbot-innovazione
TYPST ?= typst
FLAGS := --font-path fonts

.PHONY: pdf watch notes clean

pdf:
	$(TYPST) compile $(FLAGS) $(MAIN).typ

watch:
	$(TYPST) watch $(FLAGS) $(MAIN).typ

# Speaker notes for pdfpc: `pdfpc $(MAIN).pdf`
notes:
	$(TYPST) query --root . $(FLAGS) $(MAIN).typ --field value --one "<pdfpc-file>" > $(MAIN).pdfpc

clean:
	rm -f $(MAIN).pdf $(MAIN).pdfpc
