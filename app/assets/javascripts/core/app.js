var Payment  = (function () {

	var operationDemolay = [
						{type: 'elevacao', price:90, attributes:['data_elevacao']}, 
						{type: 'renovacao_cid', price:0, attributes:['capitulo']},  
						{type: 'renovacao_cid_senior', price:0, attributes:['capitulo']},
						{type: 'renovacao_cid_vitalicio', price:0, attributes:['capitulo']},
						{type: 'formulario_conselho', price:0, attributes:['capitulo']},
						{type: 'grau_cavaleiro', price:0, attributes:['data_investidura','convento']},
						{type: 'regularizacao_cadastral', price:0, attributes:['data_nascimento','data_regularizacao']},
						{type: 'requisicao_carta', price:0, attributes:['nome_organizacao_filiada']},
						{type: 'segunda_via', price:0, attributes:['tipo_documento']},
	];

	var operationCapituloConvento = null;

	function verifySelected(){
		if($('#order_tipo').val()=='demolay'){
			$('.demolay').removeClass('hidden');
			$('.capitulo_convento').addClass('hidden');
		}else{
			$('.demolay').addClass('hidden');
			$('.capitulo_convento').removeClass('hidden');
		}
	}

	function showAttribute(value){
		var operation = null;
		console.log('val: '+value);
		if(value=='demolay'){
			operation = operationDemolay;
		}else{
			operation = operationCapituloConvento;
		}
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

	return {
	      verifySelected:verifySelected,
	      showAttribute:showAttribute
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
	$('#order_operation').val($(this).val());
});