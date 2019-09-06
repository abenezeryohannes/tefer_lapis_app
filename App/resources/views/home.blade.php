@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">Dashboard</div>

                <div class="card-body">
                    @if (session('status'))
                        <div class="alert alert-success" role="alert">
                            {{ session('status') }}
                        </div>
                    @endif
                    You are logged in!

                    @if(Auth::user()->roles->pluck('name')->contains('Department') ){
                        Department
                    }
                    @endif

                    @if(Auth::user()->roles->pluck('name')->contains('Student') )
                            @foreach($posts as $post)
                            
                                <div class="card" style="width: 18rem;">
                                <div class="card-body">
                                    <h5 class="card-title">{{$post->work_area}}</h5>
                                    <h6 class="card-subtitle mb-2 text-muted">{{$post->poster->name}}</h6>
                                    <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                                    <a href="#" class="card-link">Apply</a>
                                    <a href="#" class="card-link">Another link</a>
                                </div>
                                </div>
                            
                            @endforeach
                    @endif

                    @if(Auth::user()->roles->pluck('name')->contains('University') ){
                        
                         @foreach($posts as $post)
                                <div class="card" style="width: 18rem;">
                                <div class="card-body">
                                    <h5 class="card-title">{{$post->work_area}}</h5>
                                    <h6 class="card-subtitle mb-2 text-muted">{{$post->poster->name}}</h6>
                                    <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                                    <a href="#" class="card-link">Apply</a>
                                    <a href="#" class="card-link">Another link</a>
                                </div>
                                </div>
                        @endforeach


                    }
                    @endif

                    @if(Auth::user()->roles->pluck('name')->contains('Organization') ){
                        Organization
                    }
                    @endif

                    @if(Auth::user()->roles->pluck('name')->contains('Advisor') ){  
                        Advisor
                    }
                    @endif


                </div>
            </div>
        </div>
    </div>
</div>
@endsection
