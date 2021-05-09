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
 
declare function local:distance(  $author1,$graph,$n, $current, $seen){ 

  if(fn:empty($graph//author[name=$current]//coauthors/author)) then  0
  else 
  if($author1=$current) then $n
  else 
    let $author2:= $graph//author[name=$current] 
  (: to avoid redundency and not to pass by others twice:)
  let $coauthors := $author2/coauthors/author[not(.=$seen)]
    
     for $coauther in $coauthors
       return 
         local:distance ($author1, $graph, $n+1,$coauther/text(), ($seen , $coauthors))
       
};


let $graph := local:setUp()
let $allauthors := $graph//author
let $authors := ("Mazeyar E. Makoui",
"Gunter Saake",
"Kai-Uwe Sattler",
"Andreas Heuer",
"Malte Helmert",
"Eyke Hüllermeier",
"Bing Liu",
"Ben Liblit",
"Radu Prodan",
"Thomas Fahringer",
"Mathias Weske",
"Sanghamitra Bandyopadhyay")
for $author in $authors
    for $author1 in $authors
        let $n := local:distance($author1,  $graph,0,$author,() )
        let $d :=  if ( $n>=0 ) then 
         <distance author1="{$author1}" author2="{$author}" distance="{$n}"/>
        return $d
     
    
