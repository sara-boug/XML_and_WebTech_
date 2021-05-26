
declare function local:coauthors($sample, $author) {
    for $authors in $sample
        for $author1 in  $authors//author where  $author1 != $author
         return $author1
};

declare function local:sample($author, $dblp){ 
    for $author_ in $dblp//author where  $author_=$author
        return   $author_//parent::*
};

(: setting up coauthors graph:)
declare function local:setUp(){
let $dblp:=fn:doc("dblp-excerpt.xml")//dblp
 return<authors> {
   for $author in distinct-values( $dblp//author)
      return <author>
       <name> {$author}</name>
       {
          for $sample in  local:sample($author,$dblp)  
          return <coauthors>
             {  for $coauthor in local:coauthors($sample,$author)
                return $coauthor
              }
               </coauthors>
       }
</author>
}</authors>
};



declare function local:distance_one($graph){
  
  let $authors:= $graph/author
  for $author in $authors
    for $coauthor in $author/coauthors/author
      where $coauthor != '' 
      return <distance> <author1> {data($author/name)} </author1> <author2> {data($coauthor)} </author2> <dist>1</dist> </distance>

};
 
declare function local:distance($dblp, $graph_dist){

  let $test := trace("distance","txt")
(:  let $test2 := trace($graph_dist,"distance:"):)
  
for $author_mid in distinct-values( $dblp//author)
    for $dist_author2 in $graph_dist
      for $dist_author1 in $graph_dist
      where $author_mid = data($dist_author1/author2) and $author_mid = data($dist_author2/author1) and data($dist_author1/author1) != data($dist_author2/author2) and (local:couple_already_exist($dist_author1/author1, $dist_author2/author2, $graph_dist) eq false())
        let $var1 := data($dist_author1/dist)
       let $var2 := data($dist_author2/dist)
       let $sum := $var1+$var2 

       return <distance> {$dist_author1/author1} {$dist_author2/author2} <dist> {$sum} </dist> </distance>    
        
};

 
 
declare function local:distance2($dblp, $graph_dist, $cont){
  if ($cont = 0)
    then $graph_dist
  else 
    let $next_dist := local:distance($dblp, $graph_dist)
    let $test2 := trace(count($next_dist),"count -> next_dist: ")
    let $test2 := trace(local:height($next_dist),"height:")
    let $current_cont := local:height($next_dist)
    let $sol := ($graph_dist,$next_dist)
(: return <cont>{$current_cont}{$sol}</cont> :)
    return local:distance2($dblp, $sol, $current_cont)


};

declare function local:height($graph_dist){
  let $result:=
    if (fn:empty($graph_dist/*))
    then 0
    else 1
  return $result
};

declare function local:couple_already_exist($author1, $author2, $graph_dist){
     let $vals:= $graph_dist[author1=$author1]//author1/parent::*/author2
     let $count:= count( for $val in $vals where $val/text()=$author2
     return $val)  
  return $count>0

};

let $dblp := fn:doc("dblp-excerpt.xml")//dblp
let $graph := local:setUp()
(:let $dist_one := local:distance_one($graph)
let $result := local:distance2($dblp, $dist_one, 1)

return <sol2>{$result} </sol2>:)
return $graph

 
