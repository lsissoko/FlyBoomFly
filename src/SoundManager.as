package
{
	import net.flashpunk.Sfx;

	/**
	 * A class to handle all game sounds.
	 * 
	 * @author Rolpege, Lamine Sissoko
	 */
	public final class SoundManager
	{
		private static var instance:SoundManager = new SoundManager();
		
		// Music - static
		[Embed(source = "assets/song.mp3")] public static const music_song:Class;
		public static var background_music:Sfx = new Sfx(music_song);
		
		// Sounds - const
		[Embed(source = "assets/ExplosionShip.mp3")] public const SND_EXPLOSIONSHIP:Class;
		[Embed(source = "assets/ExplosionAlien.mp3")] public const SND_EXPLOSIONALIEN:Class;
		[Embed(source = "assets/BulletShot.mp3")] public const SND_BULLETSHOT:Class;
		[Embed(source = "assets/AlienBulletShot.mp3")] public const SND_ALIENBULLETSHOT:Class;		
		public var ExplosionShip:Sfx = new Sfx(SND_EXPLOSIONSHIP);
		public var ExplosionAlien:Sfx = new Sfx(SND_EXPLOSIONALIEN);
		public var BulletShot:Sfx = new Sfx(SND_BULLETSHOT);
		public var AlienBulletShot:Sfx = new Sfx(SND_ALIENBULLETSHOT);

		public function SoundManager(){
			if(instance)
				throw new Error("Singleton.");
		}
		
		public static function get i():SoundManager{
			return instance;
		}
		
		private static var _currentMusic:Sfx;

		public static function get currentMusic():Sfx
		{
			return _currentMusic;
		}

		public static function set currentMusic(music:Sfx):void
		{
			if(_currentMusic != music)
			{
				if(_currentMusic) _currentMusic.stop();
				_currentMusic = music;
				_currentMusic.volume = G.volumeMusic;
				_currentMusic.loop(G.volumeMusic);
			}
		}
		
		public static function stopMusic():void {
			if (_currentMusic) {
				_currentMusic.stop();
				_currentMusic = null;
			}
		}
		
		public function playSound(name:String, pan:Number=0, callback:Function=null):void
		{
			var s:Sfx = this[name] as Sfx;
			if(s.playing)
			{
				var o:Sfx = new Sfx(this["SND_"+name.toUpperCase()], callback);
				o.play(G.volumeSound);
				return;
			}
			s.complete = callback;
			s.play(G.volumeSound);
		}
	}
}