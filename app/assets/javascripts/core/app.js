var Payment  = (function () {

	var operation = null;
	var operationDemolay = [
						{type: 'iniciacao', price:2, attributes:['data_iniciacao']},
						{type: 'elevacao', price:70, attributes:['data_elevacao']}, 
						{type: 'renovacao_cid', price:65, attributes:['capitulo']},  
						{type: 'renovacao_cid_senior', price:75, attributes:['capitulo']},
						{type: 'renovacao_cid_vitalicio', price:650, attributes:['capitulo']},
						{type: 'formulario_conselho', price:75, attributes:['capitulo']},
						{type: 'grau_cavaleiro', price:60, attributes:['data_investidura','convento']},
						{type: 'regularizacao_cadastral', price:100, attributes:['data_nascimento','data_regularizacao']},
						{type: 'requisicao_carta', price:30, attributes:['nome_organizacao_filiada']},
						{type: 'segunda_via', price:10, attributes:['tipo_documento']},
	];

	var operationCapituloConvento = null;

	function verifySelected(){
		if($('#order_tipo').val()=='demolay'){
			operation = operationDemolay;

			$('.demolay').removeClass('hidden');
			$('.capitulo_convento').addClass('hidden');
		}else{
			operation = operationCapituloConvento;

			$('.demolay').addClass('hidden');
			$('.capitulo_convento').removeClass('hidden');
		}
	}

	function showAttribute(value){
		//console.log('val: '+value);
		if(operation){
			var result = $('#operation_'+value).val();
			$.each(operation, function(i, obj) {
				console.log('go');
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
			if(obj.type == value){
				$('.price h4').html('R$ '+obj.price+',00');
				$('#order_price').val(obj.price)
				return false;
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

$('select[id*="operation"]').change(function(){
	Payment.showAttribute(orderType.val());
	Payment.showPrice($(this).val());
});

$("#order_cpf").mask("999.999.999-99");