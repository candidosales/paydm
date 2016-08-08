paydm - Sistema de Pagamento DeMolay
=====

**OBS:** Requer conta no PagSeguro
[![PagSeguro](https://stc.pagseguro.uol.com.br/pagseguro/i/logos/logo_pagseguro200x41.1470259085855.png)](https://pagseguro.uol.com.br/)


## Primeiros passos

### Atualize com seu Token do PagSeguro no config/initializers/pagseguro.rb

```ruby
PagSeguro.configure do |config|
  config.token    = 'SEU_TOKEN'
  config.email    = 'SEU_EMAIL' # O mesmo e-mail de acesso a conta PagSeguro
  config.encoding = 'UTF-8'
  config.environment = :production
end
```

### Para atualizar os valores das taxas ou alterar os campos para cada tipo de taxa atualize o arquivo app/assets/javascripts/core/app.js

```javascript
var operationDemolay = [
    {type: 'iniciacao', price:180, attributes:['data_iniciacao']},
    {type: 'renovacao_cid', price:74, attributes:['capitulo']},
    {type: 'renovacao_cid_senior', price:74, attributes:['capitulo']},
    {type: 'renovacao_cid_vitalicio', price:810, attributes:['capitulo']},
    {type: 'formulario_conselho', price:74, attributes:['capitulo']},
    {type: 'grau_cavaleiro', price:69, attributes:['data_investidura','convento']},
    {type: 'regularizacao_cadastral', price:2, attributes:['data_nascimento','data_regularizacao']},
    {type: 'requisicao_carta', price:35, attributes:['nome_organizacao_filiada']},
    {type: 'segunda_via', price:15, attributes:['tipo_documento']},
];

var operationCapituloConvento = [
    {type: 'iniciacao_lote', price:180, attributes:['data_iniciacao']},
    {type: 'elevacao_lote', price:70, attributes:['data_iniciacao']},
    {type: 'grau_cavaleiro_lote', price:69, attributes:['data_iniciacao']},
];
```

Os campos que podem ser usados são:
* Data de iniciação: **data_iniciacao**
* Data de investidura: **data_investidura**
* Data de nascimento: **data_nascimento**
* Data de regularização: **data_regularizacao**
* Capítulo / Loja: **capitulo**
* Convento: **convento**
* Nome da organização filiada: **nome_organizacao_filiada**
* Tipo de documento: **tipo_documento**

Você adicionar ou remover de cada tipo de pagamento pelo valor **attributes**

## Use o Heroku como servidor
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/candidosales/paydm)

### Deploy de atualizações

Após commitar no master faça:
```
git push heroku
```

## Roadmap
- [x] Botão para deploy rápido do Heroku
- [ ] Gerenciar, criar e editar tipos de pagamentos pelo administrador
- [ ] Trocar API do PagSeguro pelo administrador