(:5:)
for $b in doc("db/bib/bib.xml")//book
let $a := $b/author/last
return $a

(:6:)
let $doc := doc("db/bib/bib.xml")
for $book in $doc//book
for $title in $book/title
for $author in $book/author
  return 
  <ksiazka>
    {$author}
    {$title}
  </ksiazka>

(:7:)
let $doc := doc("db/bib/bib.xml")
for $book in $doc//book
for $title in $book/title
for $author in $book/author
return
<ksiazka>
<autor>
{$author/first/text()}
{$author/last/text()}
</autor>
<tytul>
{$title/text()}
</tytul>
</ksiazka>


(:8:)
let $doc := doc("db/bib/bib.xml")
for $book in $doc//book
for $title in $book/title
for $author in $book/author
return
<ksiazka>
<autor>
{concat($author/last/text(), " ", $author/first/text())}
</autor>
<tytul>
{$title/text()}
</tytul>
</ksiazka>


(:9:)
let $doc := doc("db/bib/bib.xml")
return
<wynik>
{
for $book in $doc//book
for $title in $book/title
for $author in $book/author
return
<ksiazka>
<autor>
{concat($author/last/text(), " ", $author/first/text())}
</autor>
<tytul>
{$title/text()}
</tytul>
</ksiazka>
}
</wynik>

(:10:)
let $doc := doc("db/bib/bib.xml")
let $book := $doc//book[title = "Data on the Web"]
return
<imiona>
    {
        for $author in $book/author/first/text()
        return <imie>{$author}</imie>
    }
</imiona>

(:11:)
let $doc := doc("db/bib/bib.xml")
for $book in $doc//book[title = 'Data on the Web']
return 
  <DataOnTheWeb>
    {$book}
  </DataOnTheWeb>

(:12:)
let $doc := doc("db/bib/bib.xml")
return
<Data>
    {
        for $book in $doc//book[contains(title, "Data")]
        for $author in $book/author
        return <nazwisko>{data($author/last)}</nazwisko>
    }
</Data>

(:13:)
let $doc := doc("db/bib/bib.xml")
for $book in $doc//book[contains(title, "Data")]
return
<Data>
    <title>{data($book/title)}</title>
    {
        for $author in $book/author
        return <nazwisko>{data($author/last)}</nazwisko>
    }
</Data>



(:14:)
let $doc := doc("db/bib/bib.xml")
for $book in $doc//book
where count($book/author) <= 2
return 
<title>{data($book/title)}</title>

(:15:)
let $doc := doc("db/bib/bib.xml")
for $book in $doc//book
return 
<ksiazka>
    <title>{data($book/title)}</title>
    <autorow>{count($book/author)}</autorow>
</ksiazka>

(:16:)
let $doc := doc("db/bib/bib.xml")
let $years := $doc//book/@year
let $minYear := min($years)
let $maxYear := max($years)
return 
<przedział>{concat($minYear, " - ", $maxYear)}</przedział>

(:17:)
let $doc := doc("db/bib/bib.xml")
let $prices := $doc//book/price
let $maxPrice := max($prices)
let $minPrice := min($prices)
let $difference := $maxPrice - $minPrice
return 
<różnica>{$difference}</różnica>

(:18:)
let $doc := doc("db/bib/bib.xml")
let $minPrice := min($doc//book/price)
return
<najtańsze>
    {
        for $book in $doc//book[price = $minPrice]
        return 
        <najtańsza>
            <title>{data($book/title)}</title>
            {
                for $author in $book/author
                return 
                <author>
                    <last>{data($author/last)}</last>
                    <first>{data($author/first)}</first>
                </author>
            }
        </najtańsza>
    }
</najtańsze>


(:19:)
let $doc := doc("db/bib/bib.xml")
for $author in distinct-values($doc//book/author/last)
return 
<autor>
    <last>{ $author }</last>
    {
        for $book in $doc//book[author/last = $author]
        return <title>{data($book/title)}</title>
    }
</autor>

(:20:)
let $a := collection("db/shakespeare")//PLAY/TITLE
return
<wynik>{
$a
}</wynik>

(:21:)
for $play in collection("db/shakespeare")//PLAY
where some $line in $play/ACT/SCENE/SPEECH/LINE satisfies
contains($line, "or not to be")
return $play/TITLE

(:22:)
for $play in collection("db/shakespeare")//PLAY
return
  <sztuka tytul="{$play/TITLE/text()}">
  <postaci>{count($play/PERSONAE/PERSONA | $play/PERSONAE/PGROUP/PERSONA)}</postaci>
  <aktow>{count($play/ACT)}</aktow>
  <scen>{count($play/ACT/SCENE)}</scen>
  </sztuka>