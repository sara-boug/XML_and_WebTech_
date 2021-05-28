declare function local:couple_already_exist($author1, $author2, $graph){
  let $vals:= $graph//distance[author1=$author1]//author1/     parent::*/author2
  let $count:= count( for $val in $vals where $val/text()=$author2
     return $val)
  
  return $count>1
  
};

 

let $graph :=<distances> 
<distance><author1>Gunter Saake</author1><author2>Kai-Uwe Sattler</author2>
<dist>1</dist>
</distance>
<distance>
<author1 name ="Gunter Saake">Gunter Saake</author1>
<author2>Andreas Heuer</author2>
<dist>1</dist>
</distance> 
</distances>


let $data :=local:couple_already_exist('Gunter Saake', "Andreas Heuer", $graph)

return  $data