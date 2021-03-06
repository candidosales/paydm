var Payment  = (function () {

	var operation = null;
	var operationDemolay = [
                    //  {type: 'inscricao_evento', price:40, attributes:['capitulo','grau_cavaleiro']}
						{type: 'iniciacao', price:84, attributes:['data_iniciacao']},
						{type: 'elevacao', price:84, attributes:['data_iniciacao']},
						{type: 'renovacao_cid', price:84, attributes:['capitulo']},
						{type: 'renovacao_cid_senior', price:84, attributes:['capitulo']},
						{type: 'renovacao_cid_macom', price:84, attributes:['capitulo']},
						{type: 'renovacao_cid_vitalicio', price:803.25, attributes:['capitulo']},
						{type: 'formulario_conselho', price:74, attributes:['capitulo']},
						{type: 'grau_cavaleiro', price:84, attributes:['data_investidura','convento']},
						{type: 'regularizacao_cadastral', price:2.10, attributes:['data_nascimento','data_regularizacao']},
						{type: 'requisicao_carta', price:36.75, attributes:['nome_organizacao_filiada']},
						{type: 'segunda_via', price:15.75, attributes:['tipo_documento']},
	];

	var operationCapituloConvento = [
						{type: 'iniciacao_lote', price:180, attributes:['data_iniciacao']},
						{type: 'elevacao_lote', price:70, attributes:['data_iniciacao']},
						{type: 'grau_cavaleiro_lote', price:69, attributes:['data_iniciacao']},
	];

	function verifySelected(){
		if($('#order_tipo').val()=='demolay'){
			operation = operationDemolay;

			$('.demolay').removeClass('hidden');
			$('.demolay input').prop('disabled', false);

			$('.capitulo_convento').addClass('hidden');
			$('.capitulo_convento input').prop('disabled', true);
		}else{
			operation = operationCapituloConvento;

			$('.demolay').addClass('hidden');
			$('.demolay input').prop('disabled', true);

			$('.capitulo_convento').removeClass('hidden');
			$('.capitulo_convento input').prop('disabled', false);
		}
		$("#order_cpf:enabled").mask("999.999.999-99");

	}

	function showAttribute(value){
		//console.log('val: '+value);
		if(operation){
			var result = $('#operation_'+value).val();
			$.each(operation, function(i, obj) {
				if(obj.type == result){
					console.log('igual');
					$('.sub-attributes').children('.columns').addClass('hidden');
					obj.attributes.forEach(function(obj){
						$('.'+obj).removeClass('hidden');
					});
					return false;
				}
			});
			setOrderOperation(result);
			console.log('result: '+result);
			showPrice(result);
		}
	}

	function showPrice(value){
		operation.forEach(function(obj){
			if($('#order_tipo').val()=='demolay'){
				if(obj.type == value){
					$('.price h4').html('R$ '+obj.price.toFixed(2));
					$('#order_price').val(obj.price)
					return false;
				}
			}else{
				if(obj.type == value){
					$('.price h4').html('R$ '+priceCapituloConvento(obj.price.toFixed(2)));
					$('#order_price').val(priceCapituloConvento(obj.price));
					return false;
				}
			}
		});
	}

	function getOperation(value){
		return operation;
	}

	function setOrderOperation(value){
		console.log('order_operation: '+value);
		$('#order_operation').val(value);
	}

	function priceCapituloConvento(value){
		var qtd = $('#order_qtd_membro').val();
		return value*qtd;

	}

	return {
	      verifySelected:verifySelected,
	      showAttribute:showAttribute,
	      showPrice:showPrice,
	      getOperation:getOperation,
	      setOrderOperation:setOrderOperation
	    }
}());

var orderType = $('#order_tipo');

Payment.verifySelected();
Payment.showAttribute(orderType.val());

orderType.change(function(){
	var val = $(this).val();
	console.log('type: '+val);
	Payment.verifySelected();
	Payment.showAttribute(val);
});

$('select[id*="operation"]').change(function(){-
	Payment.showAttribute(orderType.val());
	Payment.showPrice($(this).val());
});

$('#order_qtd_membro').change(function(){
	console.log('value_qtd_membro: '+$(this).val()+' / select: '+$('select[id="operation_capitulo_convento"]').val());
	Payment.showPrice($('select[id="operation_capitulo_convento"]').val());
});



$('#new_order').on('invalid', function () {
    var invalid_fields = $(this).find('[data-invalid]');
    var count = 0;
    console.log(invalid_fields);
    $.each(invalid_fields,function(key, value){
    	console.log(value.disabled);
    	if(!value.disabled){
    		count = count + 1;
    		console.log('count: '+count);
    	}
    });
    if(count==0){
    	console.log('Tem algum campo desabilitado sendo validado, continuar com o submit\n\nSubmeteu');

		$('#new_order').unbind('submit validate').trigger('valid').removeAttr('data-invalid').submit();
    }
  }).on('valid', function () {
    console.log('valid!');
  });
