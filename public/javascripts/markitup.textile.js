// -------------------------------------------------------------------
// markItUp!
// -------------------------------------------------------------------
// Copyright (C) 2008 Jay Salvat
// http://markitup.jaysalvat.com/
// -------------------------------------------------------------------
// Textile tags example
// http://en.wikipedia.org/wiki/Textile_(markup_language)
// http://www.textism.com/
// -------------------------------------------------------------------
// Feel free to add more tags
// -------------------------------------------------------------------
mySettings = {
	onShiftEnter:		{keepDefault:false, replaceWith:'\n\n'}, 
	markupSet: [
		{name:'Heading 1', key:'1', openWith:'h1(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
		{name:'Heading 2', key:'2', openWith:'h2(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
		{name:'Heading 3', key:'3', openWith:'h3(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
		{name:'Heading 4', key:'4', openWith:'h4(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
		{name:'Heading 5', key:'5', openWith:'h5(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
		{name:'Heading 6', key:'6', openWith:'h6(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
		{name:'Paragraph', key:'P', openWith:'p(!(([![Class]!]))!). '},
		{separator:'---------------' },
		{name:'Bold', key:'B', closeWith:'*', openWith:'*'},
		{name:'Italic', key:'I', closeWith:'_', openWith:'_'},
		{name:'Stroke through', key:'S', closeWith:'-', openWith:'-'},
		{separator:'---------------' },
		{name:'Bulleted list', openWith:'(!(* |!|*)!)'},
		{name:'Numeric list', openWith:'(!(# |!|#)!)'}, 
		{separator:'---------------' },
		{name:'Picture', replaceWith:'![![Source:!:http://]!]([![Alternative text]!])!'}, 
		{name:'Link', openWith:'"', closeWith:'([![Title]!])":[![Link:!:http://]!]', placeHolder:'Your text to link here...' },
		{separator:'---------------' },
		{name:'Quotes', openWith:'bq(!(([![Class]!])!)). '},
		{name:'Code', openWith:'@', closeWith:'@'},
		{name:'Pre', dropMenu: [
			{ name:'Normal', openWith:'<pre>', closeWith:'</pre>'},
		  { name:'Bash', openWith:'<pre class="brush: bash;">', closeWith:'</pre>'},
		  { name:'C++', openWith:'<pre class="brush: cpp;">', closeWith:'</pre>'},
		  { name:'CSharp', openWith:'<pre class="brush: csharp;">', closeWith:'</pre>'},
		  { name:'Python', openWith:'<pre class="brush: python;">', closeWith:'</pre>'},
		  { name:'Ruby',openWith:'<pre class="brush: ruby;">', closeWith:'</pre>'}
  		]
		},
		{	name:'Table generator', 
			className:'tablegenerator', 
			placeholder:"YourText",
				replaceWith:function(h) {
				cols = prompt("Number of columns:");
				rows = prompt("Number of rows:");
				textile = "";
					for (r = 0; r < rows; r++) {
						for (c = 0; c < cols; c++) {
							textile += "|"+(h.placeholder||"");	
						}
						textile += "|\n";
					}
				return textile;
			}
		},
		{	name:'Colors', className:'palette', dropMenu: [
				{name:'Yellow',	replaceWith:'#FCE94F',	className:"col1-1" },
				{name:'Yellow',	replaceWith:'#EDD400', 	className:"col1-2" },
				{name:'Yellow', replaceWith:'#C4A000', 	className:"col1-3" },
				
				{name:'Orange', replaceWith:'#FCAF3E', 	className:"col2-1" },
				{name:'Orange', replaceWith:'#F57900', 	className:"col2-2" },
				{name:'Orange', replaceWith:'#CE5C00', 	className:"col2-3" },
				
				{name:'Brown', 	replaceWith:'#E9B96E', 	className:"col3-1" },
				{name:'Brown', 	replaceWith:'#C17D11', 	className:"col3-2" },
				{name:'Brown',	replaceWith:'#8F5902', 	className:"col3-3" },
				
				{name:'Green', 	replaceWith:'#8AE234', 	className:"col4-1" },
				{name:'Green', 	replaceWith:'#73D216', 	className:"col4-2" },
				{name:'Green',	replaceWith:'#4E9A06', 	className:"col4-3" },
				
				{name:'Blue', 	replaceWith:'#729FCF', 	className:"col5-1" },
				{name:'Blue', 	replaceWith:'#3465A4', 	className:"col5-2" },
				{name:'Blue',	replaceWith:'#204A87', 	className:"col5-3" },
	
				{name:'Purple', replaceWith:'#AD7FA8', 	className:"col6-1" },
				{name:'Purple', replaceWith:'#75507B', 	className:"col6-2" },
				{name:'Purple',	replaceWith:'#5C3566', 	className:"col6-3" },
				
				{name:'Red', 	replaceWith:'#EF2929', 	className:"col7-1" },
				{name:'Red', 	replaceWith:'#CC0000', 	className:"col7-2" },
				{name:'Red',	replaceWith:'#A40000', 	className:"col7-3" },
				
				{name:'Gray', 	replaceWith:'#FFFFFF', 	className:"col8-1" },
				{name:'Gray', 	replaceWith:'#D3D7CF', 	className:"col8-2" },
				{name:'Gray',	replaceWith:'#BABDB6', 	className:"col8-3" },
				
				{name:'Gray', 	replaceWith:'#888A85', 	className:"col9-1" },
				{name:'Gray', 	replaceWith:'#555753', 	className:"col9-2" },
				{name:'Gray',	replaceWith:'#000000', 	className:"col9-3" }
			]
		}
	]
};
