-- Enable required extensions
create extension if not exists "uuid-ossp";
create extension if not exists "vector";

-- PROFILES
create table public.profiles (
  id uuid references auth.users not null primary key,
  username text,
  avatar_url text,
  style_vibes text[],
  credits int default 0,
  style_archetype text,
  preferences jsonb,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);
alter table public.profiles enable row level security;
create policy "Public profiles are viewable by everyone." on public.profiles
  for select using (true);
create policy "Users can insert their own profile." on public.profiles
  for insert with check (auth.uid() = id);
create policy "Users can update own profile." on public.profiles
  for update using (auth.uid() = id);

-- CLOSET ITEMS
create table public.closet_items (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) not null,
  name text not null,
  category text not null,
  image_url text not null,
  brand text,
  purchase_price decimal,
  embedding vector(768), -- For Semantic Search
  metadata jsonb, -- Color, Type, Season
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);
alter table public.closet_items enable row level security;
create policy "Users can view own closet items." on public.closet_items
  for select using (auth.uid() = user_id);
create policy "Users can insert own closet items." on public.closet_items
  for insert with check (auth.uid() = user_id);
create policy "Users can update own closet items." on public.closet_items
  for update using (auth.uid() = user_id);
create policy "Users can delete own closet items." on public.closet_items
  for delete using (auth.uid() = user_id);

-- STYLE RECIPES (Trend Intelligence)
create table public.style_recipes (
  id uuid default uuid_generate_v4() primary key,
  ingredients jsonb, -- The Query Logic
  vibe_tags text[],
  source_url text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);
alter table public.style_recipes enable row level security;
create policy "Style recipes are viewable by everyone." on public.style_recipes
  for select using (true);

-- USER FACTS (Agent Memory)
create table public.user_facts (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) not null,
  fact_text text not null, -- "User hates wool"
  embedding vector(768),
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);
alter table public.user_facts enable row level security;
create policy "Users can view own facts." on public.user_facts
  for select using (auth.uid() = user_id);
create policy "Users can insert own facts." on public.user_facts
  for insert with check (auth.uid() = user_id);

-- BODY MODELS (Virtual Try-On)
create table public.body_models (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) not null,
  image_url text not null,
  pose_landmarks jsonb, -- Shoulders, Hips
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);
alter table public.body_models enable row level security;
create policy "Users can view own body models." on public.body_models
  for select using (auth.uid() = user_id);
create policy "Users can insert own body models." on public.body_models
  for insert with check (auth.uid() = user_id);
create policy "Users can update own body models." on public.body_models
  for update using (auth.uid() = user_id);
create policy "Users can delete own body models." on public.body_models
  for delete using (auth.uid() = user_id);

-- SAVED OUTFITS / RECOMMENDATIONS
create table public.saved_outfits (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) not null,
  title text not null,
  image_url text,
  item_ids uuid[], -- References closet_items(id)
  meta_data jsonb, -- Stores confidence, reasoning, tags
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  last_worn_at timestamp with time zone
);
alter table public.saved_outfits enable row level security;
create policy "Users can view own outfits." on public.saved_outfits
  for select using (auth.uid() = user_id);
create policy "Users can insert own outfits." on public.saved_outfits
  for insert with check (auth.uid() = user_id);
create policy "Users can update own outfits." on public.saved_outfits
  for update using (auth.uid() = user_id);
create policy "Users can delete own outfits." on public.saved_outfits
  for delete using (auth.uid() = user_id);

-- DAILY LOGS (Optional, for tracking history)
create table public.daily_logs (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) not null,
  outfit_id uuid references public.saved_outfits(id),
  date date not null default CURRENT_DATE,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(user_id, date)
);
alter table public.daily_logs enable row level security;
create policy "Users can view own logs." on public.daily_logs
  for select using (auth.uid() = user_id);
create policy "Users can insert own logs." on public.daily_logs
  for insert with check (auth.uid() = user_id);

-- VTO CACHE (Cost Optimization)
create table public.vto_cache (
  id uuid default uuid_generate_v4() primary key,
  hash text not null unique, -- Hash(body_id + item_ids)
  result_url text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);
alter table public.vto_cache enable row level security;
create policy "VTO cache is viewable by everyone." on public.vto_cache
  for select using (true);
