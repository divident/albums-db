Select  au.name author_name, a.name album_name, a.year, sc.avg_Score, sc.count_rating, t.album_duration, t.avg_album_track_rating
from album a
inner join (
	select als.fk_album, avg(als.rating) avg_Score, count(als.rating) count_rating
	from albumscore als
	group by als.fk_album
) sc on sc.fk_album=a.idAlbum
inner join (
	select ta.fk_album album, sum(t.duration) album_duration, avg(ts.rating) avg_album_track_rating
	from track t
	inner join tracktoalbum ta on ta.fk_track=t.idtrack
	inner join trackscore ts on ts.fk_track=t.idtrack
	group by ta.fk_album
) t on t.album=a.idAlbum
inner join author au on au.idauthor=a.fk_author
order by sc.avg_Score desc, t.avg_album_track_rating desc
limit 100