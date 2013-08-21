var Payment  = (function () {

	var operationDemolay = [
						{type: 'elevacao', value:90, attributes:['data_elevacao']}, 
						{type: 'renovacao-cid', value:0, attributes:['capitulo']},  
						{type: 'renovacao-cid-senior', value:0, attributes:['capitulo']},
						{type: 'renovacao-cid-vitalicio', value:0, attributes:['capitulo']},
						{type: 'formulario-conselho', value:0, attributes:['capitulo']},
						{type: 'grau-cavaleiro', value:0, attributes:['data_investidura','convento']},
						{type: 'regularizacao-cadastral', value:0, attributes:['data_nascimento','data_regularizacao']},
						{type: 'requisicao-carta', value:0, attributes:['nome_organizacao_filiada']},
						{type: 'segunda-via', value:0, attributes:['tipo_documento']},
	];

	var operationCapituloConvento = null;

	function verifySelected(){
		if($('#type').val()=='demolay'){
			$('.demolay').removeClass('hidden');
			$('.capitulo-convento').addClass('hidden');
		}else{
			$('.demolay').addClass('hidden');
			$('.capitulo-convento').removeClass('hidden');
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
			if(obj.type == $('#operation-'+value).val()){
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

Payment.verifySelected();
Payment.showAttribute($('#type').val());

$('#type').change(function(){
	var val = $(this).val();
	console.log('type: '+val);
	Payment.verifySelected();
	Payment.showAttribute(val);
});

$('select[id*="operation"]').change(function(){
	Payment.showAttribute($('#type').val());
});