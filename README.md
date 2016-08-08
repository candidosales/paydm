paydm - Sistema de Pagamento DeMolay
=====

## Motivação
O sistema de pagamento on-line foi ideliazado pelo Ir. Marcelo Victor Leal com o objetivo de facilitar o cumprimento de taxas através de um sistema web, proporcionando maior controle da tesouraria do GCE e dos Capítulos de nosso estado.
Atualmente o sistema é desenvolvido e mantido pelo Ir. Cândido Sales onde qualquer capítulo do Brasil pode usar, gratuitamente, este software.

**OBS:** Requer conta no PagSeguro
[![PagSeguro](https://stc.pagseguro.uol.com.br/pagseguro/i/logos/logo_pagseguro200x41.1470259085855.png)](https://pagseguro.uol.com.br/)


## Primeiros passos

1. Atualize com seu [Token do PagSeguro](https://pagseguro.uol.com.br/integracao/token-de-seguranca.jhtml) no [config/initializers/pagseguro.rb](https://github.com/candidosales/paydm/blob/master/config/initializers/pagseguro.rb)

```ruby
PagSeguro.configure do |config|
  config.token    = 'SEU_TOKEN'
  config.email    = 'SEU_EMAIL' # O mesmo e-mail de acesso a conta PagSeguro
  config.encoding = 'UTF-8'
  config.environment = :production
end
```

2. Para atualizar os valores das taxas ou alterar os campos para cada tipo de taxa atualize o arquivo [app/assets/javascripts/core/app.js](https://github.com/candidosales/paydm/blob/master/app/assets/javascripts/core/app.js)

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

Você pode adicionar ou remover de cada tipo de pagamento pelo valor **attributes**

## Instalação
Paydm foi projetado para rodar em provedores na nuvem como Heroku, mas pode ser instalado em qualquer lugar. Para uma instalação rápida você pode configurar no Heroku clicando neste botão:
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/candidosales/paydm)

Requisitos:

* Ruby 2.2
* Rails 4.2
* Postgres
* Um servidor como Unicorn ou Puma

### Deploy de atualizações

Após commitar no master faça:
```
git push heroku
```

## Roadmap
- [x] Botão para deploy rápido do Heroku
- [ ] Desenvolver os testes
- [ ] Atualizar para o Rails 5
- [ ] Gerenciar, criar e editar tipos de pagamentos pelo administrador
- [ ] Trocar API do PagSeguro pelo administrador

## Contribua

1. Faça fork do projeto ( https://github.com/candidosales/paydm )
2. Crie o branch com sua feature (`git checkout -b my-new-feature`)
3. Escreva testes para cobrir suas melhorias, e documente descrevendo o que sua feature é/faz
4. Commit suas alterações (`git commit -am 'Add some feature'`)
5. Push para o branch (`git push origin my-new-feature`)
6. Crie um novo Pull Request

## Autores
* **Cândido Sales** - [twitter](https://twitter.com/candidosales) - [facebook](https://www.facebook.com/candidosales)
* **Marcelo Leal** - [twitter](https://twitter.com/marceleal) - [facebook](https://www.facebook.com/marcelo.v.leal)

## Licença

Este projeto é open source sob a [Licença MIT](https://opensource.org/licenses/MIT).