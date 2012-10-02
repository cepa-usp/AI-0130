﻿package  
{
	import cepa.ai.AI;
	import cepa.utils.ToolTip;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import pipwerks.SCORM;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Main extends AtividadeInterativa
	{
		//Camadas:
		private var shapeLayer:Sprite;
		private var particulasLayer:Sprite;
		
		//Shape principal
		private var backgroundShape:Forma;
		private var particulasStage:Vector.<Particula> = new Vector.<Particula>();
		
		private var draggingCharge:Particula;
		private var resultScreen:ResultScreen;
		
		private var ai:AI;
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			ai = new AI(this);
			ai.container.messageLabel.visible = false;
			
			this.scrollRect = new Rectangle(0, 0, 640, 480);
			
			cretaeLayers();
			//addButtons();
			addMainShape();
			//addPointingArraow();
			
			if (ExternalInterface.available) initLMSConnection();
			
			//stage.addEventListener(KeyboardEvent.KEY_UP, bindKeys);
		}
		
		private var pointingArrow:PointingArrow;
		private function addPointingArraow():void 
		{
			pointingArrow = new PointingArrow();
			pointingArrow.x = 640 - 25;
			pointingArrow.y = 25;
			pointingArrow.filters = [new GlowFilter(0x800000, 1, 15, 15)];
			stage.addChild(pointingArrow);
			stage.addEventListener(MouseEvent.CLICK, removeArrow);
		}
		
		private function removeArrow(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.CLICK, removeArrow);
			stage.removeChild(pointingArrow);
			pointingArrow = null;
		}
		
		private function addButtons():void 
		{
			var btnAddCargaPos:AddCargaPos = new AddCargaPos();
			var btnAddCargaNeg:AddCargaNeg = new AddCargaNeg();
			
			var btnOk:BtAvaliar = new BtAvaliar();
			btnOk.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { btnOk.gotoAndStop(2) } )
			btnOk.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void { btnOk.gotoAndStop(1) } )
			
			//var btnNovamente:BtNovamente = new BtNovamente();
			//btnNovamente.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void { btnNovamente.gotoAndStop(2) } )
			//btnNovamente.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void { btnNovamente.gotoAndStop(1) } )
			
			var ttPos:ToolTip = new ToolTip(btnAddCargaPos, "Adicionar carga positiva", 12, 0.8, 200, 0.6, 0.6);
			var ttNeg:ToolTip = new ToolTip(btnAddCargaNeg, "Adicionar carga negativa", 12, 0.8, 200, 0.6, 0.6);
			var ttOk:ToolTip = new ToolTip(btnOk, "Avaliar exercício", 12, 0.8, 200, 0.6, 0.6);
			//var ttNovamente:ToolTip = new ToolTip(btnNovamente, "Nova tentativa", 12, 0.8, 200, 0.6, 0.6);
			
			addChild(ttPos);
			addChild(ttNeg);
			addChild(ttOk);
			//addChild(ttNovamente);
			
			menuBar.addButton(btnAddCargaPos, initAddCargaPos, 0, true);
			menuBar.addButton(btnAddCargaNeg, initAddCargaNeg, 0, true);
			menuBar.addButton(btnOk, aval, 15, false);
			//menuBar.addButton(btnNovamente, reset, 11, false);
			btnReset.addEventListener(MouseEvent.CLICK, reset);
			
			var ttReset:ToolTip = new ToolTip(btnReset, "Nova tentativa", 12, 0.8, 200, 0.6, 0.6);
			var ttCC:ToolTip = new ToolTip(btnCC, "Créditos", 12, 0.8, 200, 0.6, 0.6);
			var ttInfo:ToolTip = new ToolTip(btnInstructions, "Ajuda", 12, 0.8, 200, 0.6, 0.6);
			
			addChild(ttReset);
			addChild(ttCC);
			addChild(ttInfo);
		}
		
		private function initAddCargaPos(e:MouseEvent):void 
		{
			var cargaPos:Particula = new Particula(true);
			cargaPos.addEventListener(MouseEvent.MOUSE_DOWN, initMovingCarga);
			cargaPos.buttonMode = true;
			particulasStage.push(cargaPos);
			particulasLayer.addChild(cargaPos);
			draggingCharge = cargaPos;
			draggingCharge.startDrag(true);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopMovingCarga);
		}
		
		private function initAddCargaNeg(e:MouseEvent):void 
		{
			var cargaNeg:Particula = new Particula(false);
			cargaNeg.addEventListener(MouseEvent.MOUSE_DOWN, initMovingCarga);
			cargaNeg.buttonMode = true;
			particulasStage.push(cargaNeg);
			particulasLayer.addChild(cargaNeg);
			draggingCharge = cargaNeg;
			draggingCharge.startDrag(true);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopMovingCarga);
		}
		
		private function initMovingCarga(e:MouseEvent):void
		{
			draggingCharge = Particula(e.target);
			if (draggingCharge.selected) draggingCharge.selected = false;
			draggingCharge.startDrag(true);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopMovingCarga);
		}
		
		private function stopMovingCarga(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopMovingCarga);
			draggingCharge.stopDrag();
			if (!backgroundShape.hitTestPoint(draggingCharge.x, draggingCharge.y, true) && 
				!backgroundShape.hitTestPoint(draggingCharge.x + raioParticula, draggingCharge.y, true) && !backgroundShape.hitTestPoint(draggingCharge.x - raioParticula, draggingCharge.y, true) &&
				!backgroundShape.hitTestPoint(draggingCharge.x, draggingCharge.y + raioParticula, true) && !backgroundShape.hitTestPoint(draggingCharge.x, draggingCharge.y - raioParticula, true)) {
				particulasStage.splice(particulasStage.indexOf(draggingCharge), 1);
				particulasLayer.removeChild(draggingCharge);
			}
			draggingCharge = null;
		}
		
		private function bindKeys(e:KeyboardEvent):void 
		{
			//trace("code: " + e.charCode);
			switch(e.charCode) {
				//case 127: // delete
					//break;
				//case 122: //ctrl+z
					//if (e.ctrlKey) {
					//}
					//break;
				//case 109: //m
				//case 77:  //M
					//trace(timeLine.getAnswer());
					//break;
				//case 65:
				//case 97:
					//break;
				//case 82: //R
				//case 114://r
					//reset();
					//break;
				case 83: //S
				case 115://s
					aval();
					break;
				//case 87: //W
				//case 119://w
					//unmarshalObjects(mementoSerialized);
					//break;
				//case 50: //2
				//
					//addAnswerEx2();
					//break;
				
			}
		}
		
		private function cretaeLayers():void 
		{
			shapeLayer = new Sprite();
			particulasLayer = new Sprite();
			resultScreen = new ResultScreen();
			
			addChild(shapeLayer);
			addChild(particulasLayer);
			
			setChildIndex(particulasLayer, 0);
			setChildIndex(shapeLayer, 0);
			addChild(resultScreen);
			resultScreen.visible = false;
			resultScreen.addEventListener(MouseEvent.CLICK, closeResultScreen);
			
			setChildIndex(backgroundLayer, 0);
		}
		
		private function closeResultScreen(e:MouseEvent):void 
		{
			resultScreen.visible = false;
		}
		
		private function addMainShape():void 
		{
			if (backgroundShape != null) {
				shapeLayer.removeChild(backgroundShape.condutor);
				shapeLayer.removeChild(backgroundShape);
			}
			
			var random:int = (Math.random() * 10) + 1;
			backgroundShape = new (getDefinitionByName("Forma" + String(random)));
			
			shapeLayer.addChild(backgroundShape);
			backgroundShape.x = 640 / 2;
			backgroundShape.y = 480 / 2;
			
			var pos:Point = backgroundShape.localToGlobal(new Point(backgroundShape.condutor.x, backgroundShape.condutor.y));
			backgroundShape.removeChild(backgroundShape.condutor);
			shapeLayer.addChild(backgroundShape.condutor);
			backgroundShape.condutor.x = pos.x;
			backgroundShape.condutor.y = pos.y;
		}
		
		private var resultadoCerto:String = "Você acertou.";
		private var resultadoErrado:String = "Ops! Tem algo errado.";
		private var textoCerto:String = "Parabéns, você posicionou corretamente as cargas.\nClique em qualquer lugar para fechar a janela.";
		//private var textoErrado:String = "Verifique se as cargas estão todas nas superfícies e se a carga total na superfície de cada cavidade e na superfície externa do condutor está correta.\nClique em qualquer lugar para fechar a janela.";
		private var scoreAtual:int;
		private var erroForaSuperficie:String = "Verifique se todas as cargas estão nas superfícies do contudor.";
		private var erroSuperficieExterna:String = "Verifique a carga total na superfície externa do condutor.";
		private var erroSuperficieInterna:String = "Verifique a carga total nas superfícies internas do condutor.";
		
		/*
		 * 1) se todas estão nas superfícies
		 * Verifique se todas as cargas estão nas superfícies do contudor.
		 * 
		 * 2) se a carga total na superfície externa está correta
		 * Verifique a carga total na superfície externa do condutor.
		 * 
		 * 3) se a carga total nas superfícies internas está correta
		 * Verifique a carga total nas superfícies internas do condutor. 
		 */
		
		private function aval(e:MouseEvent = null):void
		{
			removeFilters();
			var particulasDentro:Boolean = verificaParticulasFora();
			var pontuacaoEsperadaBorda:int = somaCargasEsperadaBorda();
			var pontuacaoBorda:int = somaParticulasBorda(Forma(backgroundShape));
			//trace("esperada borda: " + pontuacaoEsperadaBorda + " | pt: " + pontuacaoBorda);
			var pontuacaoEsperadaFilhos:Array = [];
			var pontuacaoFilhos:Array = [];
			
			for (var i:int = 0; i < Forma(backgroundShape).children.length; i++) 
			{
				pontuacaoEsperadaFilhos[i] = somaCargasEsperadaFilho(Forma(Forma(backgroundShape).children[i]));
				pontuacaoFilhos[i] = somaParticulasBorda(Forma(Forma(backgroundShape).children[i]));
				//trace("esperada filho " + i + ": " + pontuacaoEsperadaFilhos[i] + " | pt: " + pontuacaoFilhos[i]);
			}
			
			if (pontuacaoEsperadaBorda == pontuacaoBorda && String(pontuacaoEsperadaFilhos) == String(pontuacaoFilhos) && particulasDentro) {
				resultScreen.resultado.text = resultadoCerto;
				resultScreen.texto.text = textoCerto;
				scoreAtual = 100;
			}else {
				var textoErrado:String = "";
				if (!particulasDentro) {
					textoErrado += erroForaSuperficie;
					textoErrado += "\n";
				}
				if (pontuacaoEsperadaBorda != pontuacaoBorda) {
					textoErrado += erroSuperficieExterna;
					textoErrado += "\n";
				}
				if (String(pontuacaoEsperadaFilhos) != String(pontuacaoFilhos)) {
					textoErrado += erroSuperficieInterna;
				}
				
				resultScreen.resultado.text = resultadoErrado;
				resultScreen.texto.text = textoErrado;
				if(!completed) scoreAtual = 0;
			}
			
			if(ExternalInterface.available){
				if (!completed) {
					score = scoreAtual;
					completed = true;
					commit();
				}else if(scoreAtual > score){
					score = scoreAtual;
					commit();
				}
			}
			
			resultScreen.visible = true;
		}
		
		private function removeFilters():void 
		{
			for each (var item:Particula in particulasStage) 
			{
				item.selected = false;
			}
		}
		
		private function verificaParticulasFora():Boolean
		{
			var verificacao:Boolean = true;
			
			for each (var item:Particula in particulasStage) 
			{
				var onBorder:Boolean = false;
				
				if (verifyBorder(item, Forma(backgroundShape))) onBorder = true;
				for (var i:int = 0; i < Forma(backgroundShape).children.length; i++) 
				{
					if(verifyBorder(item, Forma(Forma(backgroundShape).children[i]))) onBorder = true;
				}
				
				if (!onBorder) {
					item.selected = true;
					verificacao = false;
				}
			}
			
			return verificacao;
		}
		
		public function verifyBorder(part:Particula, forma:Forma):Boolean
		{
			if (forma.borda.hitTestPoint(part.x, part.y, true) ||
				forma.borda.hitTestPoint(part.x + raioParticula, part.y, true) || forma.borda.hitTestPoint(part.x - raioParticula, part.y, true) || 
				forma.borda.hitTestPoint(part.x, part.y + raioParticula, true) || forma.borda.hitTestPoint(part.x, part.y - raioParticula, true)) return true;
			//if (forma.borda.hitTestPoint(part.x, part.y, true)) return true;
			//if (forma.borda.hitTestObject(part)) return true;
			else return false;
		}
		
		private var raioParticula:Number = 8;
		private function somaParticulasBorda(forma:Forma):int 
		{
			var pt:int = 0;
			
			for each (var item:Particula in particulasStage) 
			{
				if(verifyBorder(item, forma)){
					if (item.positivo) {
						++pt;
					}else {
						--pt;
					}
				}
			}
			
			return pt;
		}
		
		private function somaCargasEsperadaFilho(filho:Forma):int
		{
			var pt:int = 0;
			
			for (var i:int = 0; i < filho.particulas.length; i++) 
			{
				if (filho.cargasPositivas) {
					--pt;
				}else {
					++pt;
				}
			}
			
			return pt;
		}
		
		private function somaCargasEsperadaBorda():int
		{
			var pt:int = 0;
			
			for (var i:int = 0; i < Forma(backgroundShape).children.length; i++) 
			{
				var positivo:Boolean = Forma(Forma(backgroundShape).children[i]).cargasPositivas;
				for (var j:int = 0; j < Forma(Forma(backgroundShape).children[i]).particulas.length; j++) 
				{
					if (positivo) {
						++pt;
					}else {
						--pt;
					}
				}
			}
			
			return pt;
		}
		
		private function reset(e:MouseEvent = null):void
		{
			addMainShape();
			for each (var item:Particula in particulasStage)
			{
				particulasLayer.removeChild(item);
			}
			particulasStage.splice(0, particulasStage.length);
		}
		
		
		/*------------------------------------------------------------------------------------------------*/
		//SCORM:
		
		private const PING_INTERVAL:Number = 5 * 60 * 1000; // 5 minutos
		private var completed:Boolean;
		private var scorm:SCORM;
		private var scormExercise:int;
		private var connected:Boolean;
		private var score:int;
		private var pingTimer:Timer;
		private var mementoSerialized:String = "";
		
		/**
		 * @private
		 * Inicia a conexão com o LMS.
		 */
		private function initLMSConnection () : void
		{
			completed = false;
			connected = false;
			scorm = new SCORM();
			
			pingTimer = new Timer(PING_INTERVAL);
			pingTimer.addEventListener(TimerEvent.TIMER, pingLMS);
			
			connected = scorm.connect();
			
			if (connected) {
				// Verifica se a AI já foi concluída.
				var status:String = scorm.get("cmi.completion_status");	
				mementoSerialized = String(scorm.get("cmi.suspend_data"));
				var stringScore:String = scorm.get("cmi.score.raw");
			 
				switch(status)
				{
					// Primeiro acesso à AI
					case "not attempted":
					case "unknown":
					default:
						completed = false;
						break;
					
					// Continuando a AI...
					case "incomplete":
						completed = false;
						break;
					
					// A AI já foi completada.
					case "completed":
						completed = true;
						//setMessage("ATENÇÃO: esta Atividade Interativa já foi completada. Você pode refazê-la quantas vezes quiser, mas não valerá nota.");
						break;
				}
				
				//unmarshalObjects(mementoSerialized);
				scormExercise = 1;
				score = Number(stringScore.replace(",", "."));
				
				var success:Boolean = scorm.set("cmi.score.min", "0");
				if (success) success = scorm.set("cmi.score.max", "100");
				
				if (success)
				{
					scorm.save();
					pingTimer.start();
				}
				else
				{
					//trace("Falha ao enviar dados para o LMS.");
					connected = false;
				}
			}
			else
			{
				trace("Esta Atividade Interativa não está conectada a um LMS: seu aproveitamento nela NÃO será salvo.");
			}
			
			//reset();
		}
		
		/**
		 * @private
		 * Salva cmi.score.raw, cmi.location e cmi.completion_status no LMS
		 */ 
		private function commit()
		{
			if (connected)
			{
				// Salva no LMS a nota do aluno.
				var success:Boolean = scorm.set("cmi.score.raw", score.toString());

				// Notifica o LMS que esta atividade foi concluída.
				success = scorm.set("cmi.completion_status", (completed ? "completed" : "incomplete"));

				// Salva no LMS o exercício que deve ser exibido quando a AI for acessada novamente.
				success = scorm.set("cmi.location", scormExercise.toString());
				
				// Salva no LMS a string que representa a situação atual da AI para ser recuperada posteriormente.
				//mementoSerialized = marshalObjects();
				success = scorm.set("cmi.suspend_data", mementoSerialized.toString());

				if (success)
				{
					scorm.save();
				}
				else
				{
					pingTimer.stop();
					//setMessage("Falha na conexão com o LMS.");
					connected = false;
				}
			}
		}
		
		/**
		 * @private
		 * Mantém a conexão com LMS ativa, atualizando a variável cmi.session_time
		 */
		private function pingLMS (event:TimerEvent)
		{
			//scorm.get("cmi.completion_status");
			commit();
		}
		
		private function saveStatus():void
		{
			if(ExternalInterface.available){
				//mementoSerialized = marshalObjects();
				scorm.set("cmi.suspend_data", mementoSerialized);
			}
		}
		
	}

}