using Literate

input_file = "scripts/daisyworld__param.jl"
output_dir = "scripts/"

## 1. Чистый код (.jl)
Literate.script(input_file, output_dir, name="daisy_param_clean")

## 2. Блокнот Jupyter (.ipynb)
Literate.notebook(input_file, output_dir, name="daisy_param_notebook")

## 3. Документация Quarto (.qmd)
Literate.markdown(input_file, output_dir, name="daisy__quarto", flavor=Literate.QuartoFlavor())
