MAIN := presentation-2026-ai-chatbot-innovazione
TYPST ?= typst
FLAGS := --font-path fonts

.PHONY: pdf watch notes site clean

pdf:
	$(TYPST) compile $(FLAGS) $(MAIN).typ

watch:
	$(TYPST) watch $(FLAGS) $(MAIN).typ

# Speaker notes for pdfpc: `pdfpc $(MAIN).pdf`
notes:
	$(TYPST) query --root . $(FLAGS) $(MAIN).typ --field value --one "<pdfpc-file>" > $(MAIN).pdfpc

# Static page for GitHub Pages: PDF + one PNG per slide (handout, no pauses).
site:
	rm -rf _site && mkdir -p _site/slides
	$(TYPST) compile $(FLAGS) $(MAIN).typ _site/$(MAIN).pdf
	$(TYPST) compile $(FLAGS) --input handout=true --ppi 144 $(MAIN).typ "_site/slides/{0p}.png"
	ls _site/slides | awk '{printf "    <img src=\"slides/%s\" alt=\"Slide %d\" loading=\"lazy\">\n", $$0, NR}' > _site/slides.html
	sed '/<!--slides-->/r _site/slides.html' web/index.html > _site/index.html

clean:
	rm -rf $(MAIN).pdf $(MAIN).pdfpc _site
