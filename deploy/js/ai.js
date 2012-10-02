var scorm = pipwerks.SCORM; // Seção SCORM
scorm.version = "2004"; // Versão da API SCORM

$(document).ready(init); // Inicia a AI.
$(window).unload(uninit); // Encerra a AI.

/*
 * Inicia a Atividade Interativa (AI)
 */
function init () {

  // Insere o filme Flash na página HTML
  // ATENÇÃO: os callbacks registrados via ExternalInterface no Main.swf levam algum tempo para ficarem disponíveis para o Javascript. Por isso não é possível chamá-los imediatamente após a inserção do filme Flash na página HTML.
  $("#ai-container").flash({
  	swf: "swf/AI_Loader.swf",
  	width: 640,
  	height: 480,
  	play: false,
  	id: "ai",
  	allowScriptAccess: "always",
  	flashvars: {
		ai: "swf/AI-0130.swf",
		width: 640,
		height: 480,
      message: "Mensagem enviada via flashvars."
    },
    expressInstaller: "swf/expressInstall.swf"
  });

}

/*
 * Encerra a Atividade Interativa (AI)
 */ 
function uninit () {
	scorm.save();
	scorm.quit();
}