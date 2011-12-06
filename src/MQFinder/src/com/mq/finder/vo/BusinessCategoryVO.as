package com.mq.finder.vo
{
	public class BusinessCategoryVO
	{
		public var image:Class;
		public var color:Number;
		public var category:String;
		public var id:Number;
		public var selectedIcon:Class;
		public var zoom:int;
		
		public function BusinessCategoryVO(id:Number, cat:String,clr:Number,img:Class)
		{
			this.image = img;
			this.color = clr;
			this.category = cat;
			this.id = id;
		}
	}
}