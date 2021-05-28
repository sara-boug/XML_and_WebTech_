
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
  
  
  for $author_mid in distinct-values( $dblp//author)
  
    for $dist_author2 in $graph_dist
      for $dist_author1 in $graph_dist
      where $author_mid = $dist_author1/author2 and $author_mid = $dist_author2/author1 and $dist_author1/author1 != $dist_author2/author2
       let $var1 := data($dist_author1/dist)
       let  $var2 := data($dist_author2/dist)
       let $sum := $var1+$var2 
       return <distance> <author1> {$dist_author1/author1} </author1> <author2> {$dist_author2/author2} </author2> <dist>{$sum} </dist> </distance>     
   

};


let $dblp := fn:doc("dblp-excerpt.xml")//dblp
let $graph := local:setUp()
let $dist_one := local:distance_one($graph)
let $dist := local:distance($dblp,$dist_one)

return $dist

 
