# Projetos na FPGA
Projetos desenvolvidos ao longo da disciplina de projetos de CI

Dentro da pasta *python_projects* há os códigos feitos em python onde é feito para simular as maquinas de estado e o funcionamento/sequencia do hw a ser deselvonvido posteriormente em VHDL, verilog, etc.

As demais pastas do repositorio contém os projetos desenvolvidos no Vivado 2019.1.1  em VHDL, verilog, etc. Utilizado em todos estes projetos uma Nexys 4 DDR da digilent.


## Criando um projeto no padrao do repositorio

```bash
python .\python_projects\create_project.py -n teste -v 10 #exemplo da criação de um projeto
python .\python_projects\create_project.py --help #para ver as opções do algoritmo
```

## Como exportar/importar o projeto
No console do vivado entre na pasta onde deseja exportar/salvar o projeto e execute o comando:

```bash
write_project_tcl nomeDoArquivo.tcl
```


--------

Para criar um projeto a partir do arquivo **tcl** abra o vivado e va para um tcl console do vivado e execute o comando

```bash
source nomeDoArquivo.tcl
```


## Repositorio original

Mantido pelo professor: *https://bitbucket.org/Joao-Fragoso/vivado-projects/src/master/*