import PyPDF2

pdf_path = "/Users/christopherappiah-thompson/Downloads/dementia_mvvm_crash_safe_codebase.pdf"
try:
    with open(pdf_path, "rb") as file:
        reader = PyPDF2.PdfReader(file)
        text = ""
        for page in reader.pages:
            page_text = page.extract_text()
            if page_text:
                text += page_text
    with open("extracted_dementia_mvvm.txt", "w", encoding="utf-8") as out:
        out.write(text)
    print(f"Extraction complete. Output written to extracted_dementia_mvvm.txt. Characters extracted: {len(text)}")
except Exception as e:
    print(f"Error: {e}")
