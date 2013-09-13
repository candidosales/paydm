var Payment  = (function () {

	var operation = null;
	var operationDemolay = [
						{type: 'elevacao', price:90, attributes:['data_elevacao']}, 
						{type: 'renovacao_cid', price:10, attributes:['capitulo']},  
						{type: 'renovacao_cid_senior', price:10, attributes:['capitulo']},
						{type: 'renovacao_cid_vitalicio', price:10, attributes:['capitulo']},
						{type: 'formulario_conselho', price:10, attributes:['capitulo']},
						{type: 'grau_cavaleiro', price:10, attributes:['data_investidura','convento']},
						{type: 'regularizacao_cadastral', price:10, attributes:['data_nascimento','data_regularizacao']},
						{type: 'requisicao_carta', price:10, attributes:['nome_organizacao_filiada']},
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
		console.log('val: '+value);
		if(operation){
		operation.forEach(function(obj){
			console.log('itera');
			if(obj.type == $('#operation_'+value).val()){
				console.log('igual');
				$('.sub-attributes').children('.columns').addClass('hidden');
				obj.attributes.forEach(function(obj){
					$('.'+obj).removeClass('hidden');
				});
			}
		});
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

	return {
	      verifySelected:verifySelected,
	      showAttribute:showAttribute,
	      showPrice:showPrice,
	      getOperation:getOperation
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
	$('#order_operation').val($(this).val());
});