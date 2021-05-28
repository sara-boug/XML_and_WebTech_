let $dblp := fn:doc("dblp-excerpt.xml")
for $proc in $dblp//proceedings
return <proceedings>
{
 <proc_title>{$proc/title}</proc_title>,
(: Articles list :)
let $articles := ( $dblp//inproceedings[crossref=$proc/@key])
for $article in $articles
return 
  <title>{$article/title}</title>
}
</proceedings>

