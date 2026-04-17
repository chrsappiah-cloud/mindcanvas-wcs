import PyPDF2

pdf_path = "/Users/christopherappiah-thompson/Downloads/mindcanvas_mvp_blueprint.pdf"
with open(pdf_path, "rb") as file:
    reader = PyPDF2.PdfReader(file)
    text = ""
    for page in reader.pages:
        text += page.extract_text()
print(text)